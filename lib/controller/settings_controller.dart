import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/model.dart';
import '../service/service.dart';
import '../utils/json_translations.dart';

class SettingsController extends GetxController {
  RxString language = localeMap.keys.first.obs;
  RxInt themeIndex = 0.obs;
  RxString tips = "".obs;

  SettingsModel? currentSettings;

  Future<void> init() async {
    SettingsModel settings = service.loadSettings();
    if(currentSettings == null) {
      currentSettings = settings;
      language.value = currentSettings!.language;
      themeIndex.value = currentSettings!.themeIndex;
    }
    Locale? locale = Get.locale;
    if(locale != null) {
      language.value = localeMap.entries.firstWhere((entry)=>entry.value == locale, orElse: ()=>localeMap.entries.first).key;
    } else {
      language.value = localeMap.keys.first;
    }
  }

  void changeLanguage(String language) {
    Locale locale = localeMap[language]!;
    Get.updateLocale(locale);
  }

  String? check(SettingsModel settings) {
    if(!localeMap.containsKey(settings.language)) {
      return "Language NOT exist";
    }

    return null;
  }
}