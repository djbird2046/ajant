// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dao.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgentPreviewDaoAdapter extends TypeAdapter<AgentPreviewDao> {
  @override
  final int typeId = 0;

  @override
  AgentPreviewDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentPreviewDao(
      type: fields[0] as String,
      id: fields[1] as String,
      name: fields[2] as String,
      lastSessionId: fields[3] as String?,
      lastMessage: fields[4] as String?,
      updateTime: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AgentPreviewDao obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.lastSessionId)
      ..writeByte(4)
      ..write(obj.lastMessage)
      ..writeByte(5)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentPreviewDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgentMessageDaoAdapter extends TypeAdapter<AgentMessageDao> {
  @override
  final int typeId = 1;

  @override
  AgentMessageDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentMessageDao(
      sessionId: fields[0] as String,
      taskId: fields[1] as String,
      from: fields[2] as String,
      to: fields[3] as String,
      type: fields[4] as String,
      message: fields[5] as String,
      completions: fields[6] as CompletionsDao?,
      createTime: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AgentMessageDao obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.to)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.message)
      ..writeByte(6)
      ..write(obj.completions)
      ..writeByte(7)
      ..write(obj.createTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentMessageDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompletionsDaoAdapter extends TypeAdapter<CompletionsDao> {
  @override
  final int typeId = 2;

  @override
  CompletionsDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletionsDao(
      tokenUsage: fields[0] as TokenUsageDao,
      id: fields[1] as String,
      model: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CompletionsDao obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.tokenUsage)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.model);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletionsDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TokenUsageDaoAdapter extends TypeAdapter<TokenUsageDao> {
  @override
  final int typeId = 3;

  @override
  TokenUsageDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenUsageDao(
      promptTokens: fields[0] as int,
      completionTokens: fields[1] as int,
      totalTokens: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TokenUsageDao obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.promptTokens)
      ..writeByte(1)
      ..write(obj.completionTokens)
      ..writeByte(2)
      ..write(obj.totalTokens);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenUsageDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LLMConfigDaoAdapter extends TypeAdapter<LLMConfigDao> {
  @override
  final int typeId = 4;

  @override
  LLMConfigDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LLMConfigDao(
      baseUrl: fields[0] as String,
      apiKey: fields[1] as String,
      model: fields[2] as String,
      temperature: fields[3] as double,
      maxTokens: fields[4] as int,
      topP: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LLMConfigDao obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.baseUrl)
      ..writeByte(1)
      ..write(obj.apiKey)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.temperature)
      ..writeByte(4)
      ..write(obj.maxTokens)
      ..writeByte(5)
      ..write(obj.topP);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LLMConfigDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CapabilityDaoAdapter extends TypeAdapter<CapabilityDao> {
  @override
  final int typeId = 5;

  @override
  CapabilityDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CapabilityDao(
      llmConfig: fields[2] as LLMConfigDao,
      systemPrompt: fields[3] as String,
      openSpecList: (fields[4] as List?)?.cast<OpenSpecDao>(),
      sessionList: (fields[5] as List?)?.cast<SessionNameDao>(),
      timeout: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CapabilityDao obj) {
    writer
      ..writeByte(5)
      ..writeByte(2)
      ..write(obj.llmConfig)
      ..writeByte(3)
      ..write(obj.systemPrompt)
      ..writeByte(4)
      ..write(obj.openSpecList)
      ..writeByte(5)
      ..write(obj.sessionList)
      ..writeByte(6)
      ..write(obj.timeout);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CapabilityDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgentCapabilityDaoAdapter extends TypeAdapter<AgentCapabilityDao> {
  @override
  final int typeId = 6;

  @override
  AgentCapabilityDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentCapabilityDao(
      type: fields[0] as String,
      name: fields[1] as String,
      capability: fields[2] as CapabilityDao,
      timeoutSeconds: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AgentCapabilityDao obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.capability)
      ..writeByte(3)
      ..write(obj.timeoutSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentCapabilityDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApiKeyDaoAdapter extends TypeAdapter<ApiKeyDao> {
  @override
  final int typeId = 7;

  @override
  ApiKeyDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiKeyDao(
      type: fields[0] as String,
      apiKey: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApiKeyDao obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.apiKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiKeyDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OpenSpecDaoAdapter extends TypeAdapter<OpenSpecDao> {
  @override
  final int typeId = 8;

  @override
  OpenSpecDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OpenSpecDao(
      openSpec: fields[0] as String,
      apiKey: fields[1] as ApiKeyDao?,
      protocol: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OpenSpecDao obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.openSpec)
      ..writeByte(1)
      ..write(obj.apiKey)
      ..writeByte(2)
      ..write(obj.protocol);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenSpecDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionDaoAdapter extends TypeAdapter<SessionDao> {
  @override
  final int typeId = 9;

  @override
  SessionDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionDao(
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionDao obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionNameDaoAdapter extends TypeAdapter<SessionNameDao> {
  @override
  final int typeId = 10;

  @override
  SessionNameDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionNameDao(
      id: fields[0] as String,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SessionNameDao obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionNameDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SettingsDaoAdapter extends TypeAdapter<SettingsDao> {
  @override
  final int typeId = 11;

  @override
  SettingsDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsDao(
      language: fields[0] as String,
      themeIndex: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsDao obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.themeIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
