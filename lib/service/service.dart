import 'package:lite_agent_core_dart/lite_agent_core.dart';
import 'package:uuid/uuid.dart';
import '../repository/dao.dart';
import '../repository/repository.dart';
import '../model/model.dart';

Service service = Service();

class Service {
  AgentService agentService = AgentService();

  late String currentAgentId;
  late AgentCapabilityModel? currentAgentCapability;
  String currentSessionId = "";
  late String currentTaskId;

  List<Function(List<AgentPreviewModel> agentPreviewList)> agentPreviewListListenerList = [];

  void addAgentPreviewListListener(void Function(List<AgentPreviewModel> agentPreviewList) listen) {
    agentPreviewListListenerList.add(listen);
  }

  Future<List<AgentPreviewModel>> getAgentPreviewList() async {
    List<AgentPreviewModel> agentPreviewList = (await repository.getAgentPreviewList()).map( (agentPreviewDao) => AgentPreviewModel.fromDao(agentPreviewDao)).toList();
    agentPreviewList.sort((a, b)=>b.updateTime.compareTo(a.updateTime));
    return agentPreviewList;
  }

  Future<void> updateAgentPreview(AgentPreviewModel? agentPreview) async {
    if(agentPreview != null) {
      await repository.updateAgentPreview(agentPreview.toDao());
    }
    List<AgentPreviewModel> newAgentPreviewList = await getAgentPreviewList();
    for (var listen in agentPreviewListListenerList) {
      listen(newAgentPreviewList);
    }
  }

  Future<void> selectAgent(String agentId) async {
    currentAgentId = agentId;

    AgentCapabilityDao? agentCapability = await repository.getAgentCapability(agentId);
    if(agentCapability != null) {
      currentAgentCapability = AgentCapabilityModel.fromDao(agentCapability);
    }
  }

  // Future<List<AgentMessageModel>> getLastSessionMessageHistory(String agentId) async {
  //   return (repository.getLastSessionMessageHistory(agentId)).map((agentMessageDao) => AgentMessageModel.fromDao(agentMessageDao)).toList();
  // }

  List<AgentMessageModel> loadAgentMessageList(String agentId) {
    return (repository.getAgentMessageHistory(agentId)).map((agentMessageDao) => AgentMessageModel.fromDao(agentMessageDao)).toList();
  }

  Future<bool> testLLMConfig(String baseUrl, String apiKey) async {
    return await OpenAIUtil.checkLLMConfig(baseUrl, apiKey);
  }

  Future<AgentPreviewModel> addAgent(AgentCapabilityModel agentCapability) async {
    String agentId = const Uuid().v4();

    await repository.addAgentCapability(agentId, agentCapability.toDao());
    currentAgentCapability = agentCapability;

    AgentPreviewModel agentPreview = AgentPreviewModel(
        type: agentCapability.type,
        id: agentId,
        name: agentCapability.name,
        updateTime: DateTime.now()
    );

    await repository.addAgentPreview(agentPreview.toDao());

    await updateAgentPreview(null);

    currentAgentId = agentId;

    return agentPreview;
  }

  Future<void> updateAgentCapability(AgentCapabilityModel agentCapability) async {
    await repository.updateAgentCapability(currentAgentId, agentCapability.toDao());
    currentAgentCapability = agentCapability;
    currentSessionId = "";
  }

  Future<void> saveSettings(SettingsModel settings) async {
    await repository.saveSettings(settings.toDao());
  }

  SettingsModel loadSettings() {
    return SettingsModel.fromDao(repository.getSettings());
  }
  
  Future<void> startSimple(List<UserMessageModel> userMessageList, void Function(String sessionId, AgentMessageModel agentMessage) listen) async {
    SimpleCapabilityDto simpleCapability = SimpleCapabilityDto(
        llmConfig: currentAgentCapability!.capability.llmConfig.toDto(), 
        systemPrompt: currentAgentCapability!.capability.systemPrompt
    );
    SessionDto sessionDto = await agentService.initSimple(simpleCapability);
    currentSessionId = sessionDto.id;
    currentTaskId = const Uuid().v4();
    List<UserMessageDto> contentList = userMessageList.map((userMessageModel) => userMessageModel.toDto()).toList();
    UserTaskDto userTaskDto = UserTaskDto(taskId: currentTaskId, contentList: contentList);
    _dispatchUserTask(userTaskDto, listen);
    AgentMessageDto agentMessageDto = await agentService.startSimple(sessionDto.id, userTaskDto);
    _dispatchSimpleResult(agentMessageDto, listen);
  }

  Future<void> _dispatchUserTask(UserTaskDto userTaskDto, void Function(String sessionId, AgentMessageModel agentMessage) listen) async {
    String? systemPrompt = currentAgentCapability?.capability.systemPrompt;
    String taskId = userTaskDto.taskId??const Uuid().v4();
    if(systemPrompt != null && systemPrompt.isNotEmpty) {
      AgentMessageDto systemMessage = AgentMessageDto(
        sessionId: currentSessionId,
        taskId: taskId,
        from: TextRoleType.SYSTEM,
        to: TextRoleType.AGENT,
        type: TextMessageType.TEXT,
        message: systemPrompt,
        createTime: DateTime.now()
      );
      AgentMessageDao agentMessageDao = AgentMessageModel.fromDto(systemMessage).toDao();
      await repository.addAgentMessage(currentAgentId, currentSessionId, agentMessageDao);
      listen(currentSessionId, AgentMessageModel.fromDto(systemMessage));
    }

    List<Content> userMessageList = userTaskDto.contentList
        .map((userMessageDto) => _convertToContent(userMessageDto))
        .toList();

    AgentMessageDto userMessage = AgentMessageDto(
        sessionId: currentSessionId,
        taskId: taskId,
        from: TextRoleType.USER,
        to: TextRoleType.AGENT,
        type: TextMessageType.CONTENT_LIST,
        message: userMessageList,
        createTime: DateTime.now()
    );
    AgentMessageDao agentMessageDao = AgentMessageModel.fromDto(userMessage).toDao();
    await repository.addAgentMessage(currentAgentId, currentSessionId, agentMessageDao);
    listen(currentSessionId, AgentMessageModel.fromDto(userMessage));
  }

  Content _convertToContent(UserMessageDto userMessageDto) {
    switch (userMessageDto.type) {
      case UserMessageDtoType.text:
        return Content(type: ContentType.TEXT, message: userMessageDto.message);
      case UserMessageDtoType.imageUrl:
        return Content(
            type: ContentType.IMAGE_URL, message: userMessageDto.message);
    }
  }

  void _dispatchSimpleResult(AgentMessageDto agentMessageDto, void Function(String sessionId, AgentMessageModel agentMessage) listen) {
    AgentMessageDto agentMessage = AgentMessageDto(
        sessionId: currentSessionId,
        taskId: agentMessageDto.taskId,
        from: TextRoleType.AGENT,
        to: TextRoleType.USER,
        type: agentMessageDto.type,
        message: agentMessageDto.message,
        createTime: DateTime.now()
    );
    listen(currentSessionId, AgentMessageModel.fromDto(agentMessage));
  }

  Future<void> startSession(List<UserMessageModel> userMessageList, void Function(String sessionId, AgentMessageModel agentMessage) listen) async {
    Future<void> listen0(String sessionId, AgentMessageDto agentMessageDto) async {
      AgentMessageDao agentMessageDao = AgentMessageModel.fromDto(agentMessageDto).toDao();
      await repository.addAgentMessage(currentAgentId, sessionId, agentMessageDao);
      listen(sessionId, AgentMessageModel.fromDto(agentMessageDto));
    }

    currentTaskId = const Uuid().v4();
    List<UserMessageDto> contentList = userMessageList.map((userMessageModel) => userMessageModel.toDto()).toList();
    UserTaskDto userTaskDto = UserTaskDto(taskId: currentTaskId, contentList: contentList);
    try {
      if(currentSessionId.isEmpty) {
        SessionDto sessionDto = await agentService.initChat(currentAgentCapability!.capability.toDto(), listen0);
        currentSessionId = sessionDto.id;
      }
      await agentService.startChat(currentSessionId, userTaskDto);
    } on AgentNotFoundException {
      SessionDto sessionDto = await agentService.initChat(currentAgentCapability!.capability.toDto(), listen0);
      currentSessionId = sessionDto.id;
      await agentService.startChat(currentSessionId, userTaskDto);
    }

  }

  Future<void> stopChat() async {
    await agentService.stopChat(SessionTaskDto(id: currentSessionId, taskId: currentTaskId));
  }

  Future<void> clearChat() async {
    await agentService.clearChat(currentSessionId);
  }

  Future<void> deleteAgent() async {
    List<String> sessionList = repository.getSessionList(currentAgentId);

    for(String sessionId in sessionList) {
      await repository.deleteAgentMessageList(sessionId);
    }

    await repository.deleteSessionList(currentAgentId);
    await repository.deleteAgentCapability(currentAgentId);
    await repository.deleteAgentPreview(currentAgentId);

    await updateAgentPreview(null);
  }
}