import 'package:hive/hive.dart';
import 'package:lite_agent_core_dart/lite_agent_core.dart';

part 'dao.g.dart';

@HiveType(typeId: 0)
class AgentPreviewDao {
  @HiveField(0)
  String type;

  @HiveField(1)
  String id;

  @HiveField(2)
  String name;

  @HiveField(3)
  String? lastSessionId;

  @HiveField(4)
  String? lastMessage;

  @HiveField(5)
  DateTime updateTime;

  AgentPreviewDao({required this.type, required this.id, required this.name, this.lastSessionId, this.lastMessage, required this.updateTime});
}

@HiveType(typeId: 1)
class AgentMessageDao {
  @HiveField(0)
  String sessionId;

  @HiveField(1)
  String taskId;

  @HiveField(2)
  String from;

  @HiveField(3)
  String to;

  @HiveField(4)
  String type;

  @HiveField(5)
  String message;

  @HiveField(6)
  CompletionsDao? completions;

  @HiveField(7)
  DateTime createTime;

  AgentMessageDao({required this.sessionId, required this.taskId, required this.from, required this.to, required this.type, required this.message, this.completions, required this.createTime});
}

@HiveType(typeId: 2)
class CompletionsDao {

  @HiveField(0)
  TokenUsageDao tokenUsage;

  @HiveField(1)
  String id;

  @HiveField(2)
  String model;

  CompletionsDao({required this.tokenUsage, required this.id, required this.model});
}

@HiveType(typeId: 3)
class TokenUsageDao {
  @HiveField(0)
  int promptTokens;

  @HiveField(1)
  int completionTokens;

  @HiveField(2)
  int totalTokens;

  TokenUsageDao({required this.promptTokens, required this.completionTokens, required this.totalTokens});
}

@HiveType(typeId: 4)
class LLMConfigDao {
  @HiveField(0)
  String baseUrl;

  @HiveField(1)
  String apiKey;

  @HiveField(2)
  String model;

  @HiveField(3)
  double temperature;

  @HiveField(4)
  int maxTokens;

  @HiveField(5)
  double topP;

  LLMConfigDao({
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    this.temperature = 0.0,
    this.maxTokens = 4096,
    this.topP = 1.0
  });
}

@HiveType(typeId: 5)
class CapabilityDao {
  @HiveField(2)
  LLMConfigDao llmConfig;

  @HiveField(3)
  String systemPrompt;

  @HiveField(4)
  List<OpenSpecDao>? openSpecList;

  @HiveField(5)
  List<SessionNameDao>? sessionList;

  @HiveField(6)
  int timeout;

  CapabilityDao({
    required this.llmConfig,
    required this.systemPrompt,
    this.openSpecList,
    this.sessionList,
    required this.timeout
  });
}

@HiveType(typeId: 6)
class AgentCapabilityDao {
  @HiveField(0)
  String type;

  @HiveField(1)
  String name;

  @HiveField(2)
  CapabilityDao capability;

  @HiveField(3)
  int timeoutSeconds;

  AgentCapabilityDao({
    required this.type,
    required this.name,
    required this.capability,
    this.timeoutSeconds = 3600
  });
}

@HiveType(typeId: 7)
class ApiKeyDao {
  @HiveField(0)
  String type;

  @HiveField(1)
  String apiKey;

  ApiKeyDao({required this.type, required this.apiKey});
}

@HiveType(typeId: 8)
class OpenSpecDao {
  @HiveField(0)
  String openSpec;

  @HiveField(1)
  ApiKeyDao? apiKey;

  @HiveField(2)
  String protocol;

  OpenSpecDao({required this.openSpec, this.apiKey, required this.protocol});
}

@HiveType(typeId: 9)
class SessionDao {
  @HiveField(0)
  String id;

  SessionDao({required this.id});
}

@HiveType(typeId: 10)
class SessionNameDao extends SessionDao {
  @HiveField(1)
  String? name; // OpenAI: The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64.

  SessionNameDao({required super.id, String? name}) {
    final regex = RegExp(r'^[a-zA-Z0-9_-]{1,64}$');
    if (name != null && !regex.hasMatch(name)) {
      throw AgentNameException(agentName: name);
    }
  }
}

@HiveType(typeId: 11)
class SettingsDao {
  @HiveField(0)
  String language;

  @HiveField(1)
  int themeIndex;

  SettingsDao({required this.language, required this.themeIndex});
}