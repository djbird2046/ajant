import 'package:hive/hive.dart';
import 'dao.dart';

///# Storage Struct:
///
///## settings
///{"settings": settings}
///
///## agentPreview
///{AgentId: AgentPreviewDao}
///
///## capabilityList
///{agentId: agentCapability}
///
///## agentMessageList
///{sessionId: [agentMessageDao]}
///
///## agentSessionList
///{agentId: [sessionId]}

Repository repository = Repository();

class Repository {

  String settingsKey = "settings";
  String settingsLanguageDefaultValue = "English";

  late Box<SettingsDao> settingsBox;
  late Box<AgentPreviewDao> agentPreviewBox;
  late Box<AgentCapabilityDao> agentCapabilityBox;
  late Box<List> agentMessageListBox;
  late Box<List<String>> sessionIdListBox;

  Future<void> init() async {
    settingsBox = await Hive.openBox<SettingsDao>('settings');
    agentPreviewBox = await Hive.openBox<AgentPreviewDao>('agentPreview');
    agentCapabilityBox = await Hive.openBox<AgentCapabilityDao>('agentCapability');
    agentMessageListBox = await Hive.openBox<List>('agentMessageList');
    sessionIdListBox = await Hive.openBox<List<String>>('sessionList');
  }

  Future<void> saveSettings(SettingsDao settings) async {
    await settingsBox.put(settingsKey, settings);
  }

  SettingsDao getSettings() {
    return settingsBox.get(settingsKey)??SettingsDao(language: settingsLanguageDefaultValue, themeIndex: 0);
  }

  Future<void> addAgentPreview(AgentPreviewDao agentPreview) async {
    await agentPreviewBox.put(agentPreview.id, agentPreview);
  }

  Future<void> deleteAgentPreview(String agentId) async {
    await agentPreviewBox.delete(agentId);
  }

  Future<void> updateAgentPreview(AgentPreviewDao agentPreview) async {
    await agentPreviewBox.put(agentPreview.id, agentPreview);
  }

  AgentPreviewDao? getAgentPreview(String agentId) {
    return agentPreviewBox.get(agentId);
  }

  Future<List<AgentPreviewDao>> getAgentPreviewList() async {
    List<AgentPreviewDao> agentPreviewDaoList =  agentPreviewBox.values.toList();
    agentPreviewDaoList.sort((a, b)=> a.updateTime.compareTo(b.updateTime));
    return agentPreviewDaoList;
  }

  // List<AgentMessageDao> getLastSessionMessageHistory(String agentId) {
  //   String? lastSessionId = sessionIdListBox.get(agentId)?.last;
  //   if(lastSessionId != null) {
  //     List<AgentMessageDao> lastSessionAgentMessageList = getAgentMessageList(lastSessionId);
  //     return lastSessionAgentMessageList;
  //   } else {
  //     return [];
  //   }
  // }

  List<AgentMessageDao> getAgentMessageHistory(String agentId) {
    List<String> sessionIdList = sessionIdListBox.get(agentId)??[];
    List<AgentMessageDao> agentMessageList = [];
    for (var sessionId in sessionIdList) {
      List<AgentMessageDao> agentMessageDaoList = getAgentMessageList(sessionId);
      agentMessageList.addAll(agentMessageDaoList);
    }
    return agentMessageList;
  }

  Future<void> addAgentCapability(String agentId, AgentCapabilityDao agentCapability) async {
    await agentCapabilityBox.put(agentId, agentCapability);
  }

  Future<void> deleteAgentCapability(String agentId) async {
    await agentCapabilityBox.delete(agentId);
  }

  Future<void> updateAgentCapability(String agentId, AgentCapabilityDao agentCapability) async {
    await agentCapabilityBox.put(agentId, agentCapability);
  }

  Future<AgentCapabilityDao?> getAgentCapability(String agentId) async {
    return agentCapabilityBox.get(agentId);
  }

  Future<void> addAgentMessage(String agentId, String sessionId, AgentMessageDao agentMessage) async {
    List<AgentMessageDao> agentMessageList = getAgentMessageList(sessionId);
    agentMessageList.add(agentMessage);
    agentMessageListBox.put(sessionId, agentMessageList);

    List<String> sessionIdList = sessionIdListBox.get(agentId)??[];
    if(!sessionIdList.contains(sessionId)) {
      sessionIdList.add(sessionId);
      await sessionIdListBox.put(agentId, sessionIdList);
    }
  }

  Future<void> deleteAgentMessageList(String sessionId) async {
    await agentPreviewBox.delete(sessionId);
  }

  List<AgentMessageDao> getAgentMessageList(String sessionId) {
    return agentMessageListBox.get(sessionId, defaultValue: [])?.cast<AgentMessageDao>()??[];
  }

  Future<String> addSession(String agentId, String sessionId) async {
    List<String> sessionIdList = sessionIdListBox.get(agentId) ?? [];
    sessionIdList.add(sessionId);
    sessionIdListBox.put(agentId, sessionIdList);
    return sessionId;
  }

  Future<void> deleteSessionList(String agentId) async {
    await sessionIdListBox.delete(agentId);
  }

  List<String> getSessionList(String agentId) {
    return sessionIdListBox.get(agentId)??[];
  }
}