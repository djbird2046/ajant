import 'dart:convert';

import 'package:lite_agent_core_dart/lite_agent_core.dart';
import 'package:opentool_dart/opentool_dart.dart';
import '../repository/dao.dart';

class AgentType {
  static String simple = "simple";
  static String session = "session";
}

class AgentPreviewModel {
  String type;
  String id;
  String name;
  String? lastSessionId;
  String? lastMessage;
  DateTime updateTime;

  AgentPreviewModel({required this.type, required this.id, required this.name, this.lastSessionId, this.lastMessage, required this.updateTime});

  factory AgentPreviewModel.fromDao(AgentPreviewDao agentPreviewDao) => AgentPreviewModel(
    type: agentPreviewDao.type,
    id: agentPreviewDao.id,
    name: agentPreviewDao.name,
    lastSessionId: agentPreviewDao.lastSessionId,
    lastMessage: agentPreviewDao.lastMessage,
    updateTime: agentPreviewDao.updateTime
  );

  AgentPreviewDao toDao() => AgentPreviewDao(
    type: type,
    id: id,
    name: name,
    lastSessionId: lastSessionId,
    lastMessage: lastMessage,
    updateTime: updateTime
  );
}

class AgentMessageModel {
  String sessionId;
  String taskId;
  String from;
  String to;
  String type;
  dynamic message;
  Completions? completions;
  DateTime createTime;

  AgentMessageModel({required this.sessionId, required this.taskId, required this.from, required this.to, required this.type, required this.message, this.completions, required this.createTime});

  factory AgentMessageModel.fromDao(AgentMessageDao agentMessageDao) => AgentMessageModel(
      sessionId: agentMessageDao.sessionId,
      taskId: agentMessageDao.taskId,
      from: agentMessageDao.from,
      to: agentMessageDao.to,
      type: agentMessageDao.type,
      message: convertMessageJsonStringToDynamic(agentMessageDao.type,agentMessageDao.message),
      createTime: agentMessageDao.createTime
  );

  factory AgentMessageModel.fromDto(AgentMessageDto agentMessageDto) => AgentMessageModel(
      sessionId: agentMessageDto.sessionId,
      taskId: agentMessageDto.taskId,
      from: agentMessageDto.from,
      to: agentMessageDto.to,
      type: agentMessageDto.type,
      message: agentMessageDto.message,
      createTime: agentMessageDto.createTime
  );

  AgentMessageDao toDao() => AgentMessageDao(
      sessionId: sessionId,
      taskId: taskId,
      from: from,
      to: to,
      type: type,
      message: convertMessageDynamicToJsonString(type, message),
      createTime: createTime
  );

  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "taskId": taskId,
    "from": from,
    "to": to,
    "type": type,
    "message": convertMessageDynamicToJsonString(type, message),
    "createTime": createTime.toIso8601String()
  };

}

String convertMessageDynamicToJsonString(String type, dynamic message) {
  switch(type) {
    case AgentMessageType.FUNCTION_CALL_LIST: return jsonEncode(message.map((functionCall)=>functionCall.toJson()).toList());
    case AgentMessageType.TOOL_RETURN: return jsonEncode((message as ToolReturn).toJson());
    case AgentMessageType.CONTENT_LIST: return jsonEncode(message.map((content) => content.toJson()).toList());
    default: return (message as String);
  }
}

dynamic convertMessageJsonStringToDynamic(String type, String jsonString) {
  switch(type) {
    case AgentMessageType.FUNCTION_CALL_LIST: return (jsonDecode(jsonString).map((json)=>FunctionCall.fromJson(json)).toList());
    case AgentMessageType.TOOL_RETURN: return jsonDecode(jsonString) as ToolReturn;
    case AgentMessageType.CONTENT_LIST: return (jsonDecode(jsonString).map((json)=> Content.fromJson(json)).toList());
    default: return jsonString;
  }
}

class CompletionsModel {
  TokenUsage tokenUsage;

  /// When role is llm, this is current llm calling token usage
  String id;

  /// When role is llm, this is current /chat/completions return message id
  String model;

  CompletionsModel({required this.tokenUsage, required this.id, required this.model});
}

class TokenUsageModel {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  TokenUsageModel({required this.promptTokens, required this.completionTokens, required this.totalTokens});
}

class LLMConfigModel {
  String baseUrl;
  String apiKey;
  String model;
  double temperature;
  int maxTokens;
  double topP;

  LLMConfigModel({
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    this.temperature = 0.0,
    this.maxTokens = 4096,
    this.topP = 1.0
  });

  LLMConfigDao toDao() => LLMConfigDao(
      baseUrl: baseUrl,
      apiKey: apiKey,
      model: model,
      temperature: temperature,
      maxTokens: maxTokens,
      topP: topP
  );

  LLMConfigDto toDto() => LLMConfigDto(
      baseUrl: baseUrl,
      apiKey: apiKey,
      model: model,
      temperature: temperature,
      maxTokens: maxTokens,
      topP: topP
  );

  factory LLMConfigModel.fromDao(LLMConfigDao llmConfig) => LLMConfigModel(
      baseUrl: llmConfig.baseUrl,
      apiKey: llmConfig.apiKey,
      model: llmConfig.model
  );
}

class CapabilityModel {
  LLMConfigModel llmConfig;
  String systemPrompt;
  List<OpenSpecDao>? openSpecList;
  List<SessionNameDao>? sessionList;
  int timeoutSeconds;

  CapabilityModel({
    required this.llmConfig,
    required this.systemPrompt,
    this.openSpecList,
    this.sessionList,
    this.timeoutSeconds = 3600
  });

  CapabilityDao toDao() {
    return CapabilityDao(llmConfig: llmConfig.toDao(), systemPrompt: systemPrompt, timeout: timeoutSeconds);
  }

  factory CapabilityModel.fromDao(CapabilityDao capability) => CapabilityModel(
      llmConfig: LLMConfigModel.fromDao(capability.llmConfig),
      systemPrompt: capability.systemPrompt
  );

  CapabilityDto toDto() => CapabilityDto(
      llmConfig: llmConfig.toDto(),
      systemPrompt: systemPrompt
  );
}

class ApiKeyModel {
  String type;
  String apiKey;

  ApiKeyModel({required this.type, required this.apiKey});
}

class OpenSpecModel {
  String openSpec;
  ApiKeyModel? apiKey;
  String protocol;

  OpenSpecModel({required this.openSpec, this.apiKey, required this.protocol});
}

// class SessionModel {
//   String id;
//
//   SessionModel({required this.id});
//
//   factory SessionModel.fromDto(SessionDto sessionDto) => SessionModel(id: sessionDto.id);
// }
//
// class SessionNameModel extends SessionModel {
//   String? name; // OpenAI: The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64.
//
//   SessionNameModel({required super.id, String? name}) {
//     final regex = RegExp(r'^[a-zA-Z0-9_-]{1,64}$');
//     if (name != null && !regex.hasMatch(name)) {
//       throw AgentNameException(agentName: name);
//     }
//   }
// }

class AgentCapabilityModel {
  String type;
  String name;
  CapabilityModel capability;

  AgentCapabilityModel({required this.type, required this.name, required this.capability});

  AgentCapabilityDao toDao() =>
      AgentCapabilityDao(
          type: type,
          name: name,
          capability: capability.toDao()
      );

  factory AgentCapabilityModel.fromDao(AgentCapabilityDao agentCapabilityDao) =>
      AgentCapabilityModel(
          type: agentCapabilityDao.type,
          name: agentCapabilityDao.name,
          capability: CapabilityModel.fromDao(agentCapabilityDao.capability)
      );
}

enum UserMessageModelType { text, imageUrl }

Map<UserMessageModelType, UserMessageDtoType> userMessageModelToDtoMap = {
  UserMessageModelType.text: UserMessageDtoType.text,
  UserMessageModelType.imageUrl: UserMessageDtoType.imageUrl
};

class UserMessageModel {
  UserMessageModelType type;
  String message;

  UserMessageModel({required this.type, required this.message});

  UserMessageDto toDto() => UserMessageDto(
    type: userMessageModelToDtoMap[type]!,
    message: message
  );
}

class SettingsModel {
  String language;
  int themeIndex;

  SettingsModel({required this.language, required this.themeIndex});

  factory SettingsModel.fromDao(SettingsDao settings) => SettingsModel(language: settings.language, themeIndex: settings.themeIndex);

  SettingsDao toDao() => SettingsDao(language: language, themeIndex: themeIndex);
}

