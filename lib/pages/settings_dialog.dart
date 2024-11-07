import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import '../controller/settings_controller.dart';
import '../model/model.dart';
import '../theme.dart';
import '../utils/json_translations.dart';

class SettingsDialog extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  final tabController = MacosTabController(initialIndex: 0, length: 3);

  SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, ThemeMode> themePopupMenuMap = {
      "settings_dialog.settings.theme.system".tr: ThemeMode.system,
      "settings_dialog.settings.theme.light".tr: ThemeMode.light,
      "settings_dialog.settings.theme.dark".tr: ThemeMode.dark
    };
    settingsController.init();
    return MacosSheet(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "settings_dialog.title.settings".tr,
                  style: MacosTheme.of(context).typography.headline,
                ),
              ),
              Divider(color: MacosTheme.of(context).dividerColor,),
              Container(height: 4),
              Expanded(
                child: ContentArea(
                  builder: (context, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 64,
                                          child: Row(
                                            children: [
                                              Text("settings_dialog.settings.language".tr, style: MacosTheme.of(context).typography.body,),
                                            ],
                                          )),
                                      const SizedBox(width: 8),
                                      Obx(()=>MacosPopupButton<String>(
                                        value: settingsController.language.value,
                                        onChanged: (String? newValue) {
                                          settingsController.language.value = newValue??"";
                                          settingsController.changeLanguage(settingsController.language.value);
                                        },
                                        items: localeMap.keys.map<MacosPopupMenuItem<String>>((String value) {
                                          return MacosPopupMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 64,
                                          child: Row(
                                            children: [
                                              Text("settings_dialog.settings.theme".tr, style: MacosTheme.of(context).typography.body,),
                                            ],
                                          )),
                                      const SizedBox(width: 8),
                                      Obx(()=>MacosPopupButton<String>(
                                        value: themePopupMenuMap.keys.toList()[settingsController.themeIndex.value],
                                        onChanged: (String? newValue) {
                                          settingsController.themeIndex.value = themePopupMenuMap.keys.toList().indexOf(newValue!);
                                          // settingsController.theme.value = newValue??"";
                                          AppTheme appTheme = Provider.of<AppTheme>(context, listen: false);
                                          appTheme.mode = themePopupMenuMap.values.toList()[settingsController.themeIndex.value];
                                        },
                                        items: themePopupMenuMap.keys.map<MacosPopupMenuItem<String>>((String value) {
                                          return MacosPopupMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )),
                                    ],
                                  ),
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Obx(() =>Expanded(
                      child:  Text(
                        settingsController.tips.value,
                        style: const TextStyle(color: MacosColors.systemRedColor),
                      )),
                  ),
                  PushButton(
                    secondary: true,
                    controlSize: ControlSize.regular,
                    child: Text("common.cancel".tr),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 16),
                  PushButton(
                    controlSize: ControlSize.regular,
                    child: Text("common.save".tr),
                    onPressed: () {
                      SettingsModel settingsModel = SettingsModel(
                        language: settingsController.language.value,
                        themeIndex: settingsController.themeIndex.value
                      );
                      return Navigator.of(context).pop<SettingsModel>(settingsModel);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
