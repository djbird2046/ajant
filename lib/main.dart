import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'repository/repository.dart';
import 'theme.dart';
import 'repository/dao.dart';
import 'pages/main_page.dart';
import 'utils/json_translations.dart';

Future<void> main() async {
  if (!kIsWeb && Platform.isMacOS) { //Not Web and confirm macOS
    await configureMacosWindowUtils();
  }
  await initHive();

  final translations = JsonTranslations();
  await translations.loadTranslations();

  runApp(Ajant(translations: translations));
}

class Ajant extends StatelessWidget {

  final JsonTranslations translations;

  const Ajant({super.key, required this.translations});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppTheme>(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
          title: 'Ajant',
          theme: MacosThemeData.light(),
          darkTheme: MacosThemeData.dark(),
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: GetMaterialApp(
            translations: translations,
            locale: localeMap.values.first,
            fallbackLocale: localeMap.values.first,
            supportedLocales: localeMap.values,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: MainPage(),
            ),
          ),
        );
      },
    );
  }
}

Future<void> configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(AgentPreviewDaoAdapter());
  Hive.registerAdapter(AgentMessageDaoAdapter());
  Hive.registerAdapter(CompletionsDaoAdapter());
  Hive.registerAdapter(TokenUsageDaoAdapter());
  Hive.registerAdapter(LLMConfigDaoAdapter());
  Hive.registerAdapter(CapabilityDaoAdapter());
  Hive.registerAdapter(AgentCapabilityDaoAdapter());
  Hive.registerAdapter(ApiKeyDaoAdapter());
  Hive.registerAdapter(OpenSpecDaoAdapter());
  Hive.registerAdapter(SessionDaoAdapter());
  Hive.registerAdapter(SessionNameDaoAdapter());
  Hive.registerAdapter(SettingsDaoAdapter());

  await repository.init();

}