import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

const Map<String, Locale> localeMap = {
  "English": Locale('en'),
  "中文简体": Locale('zh'),
};

class JsonTranslations extends Translations {
  final Map<String, Map<String, String>> _localizedStrings = {};

  Future<void> loadTranslations() async {
    _localizedStrings['en'] = await _loadJsonFile('assets/lang/en.json');
    _localizedStrings['zh'] = await _loadJsonFile('assets/lang/zh_CN.json');
  }

  Future<Map<String, String>> _loadJsonFile(String path) async {
    String jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  @override
  Map<String, Map<String, String>> get keys => _localizedStrings;
}
