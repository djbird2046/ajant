import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import '../service/service.dart';
import '../utils/utils.dart';
import 'dart:io' as io;
import 'package:macos_ui/macos_ui.dart';
import '../model/model.dart';
import 'settings_dialog.dart';

List<PlatformMenuItem> menuBarItems(BuildContext context) {
  if (kIsWeb) {
    return [];
  } else {
    if (io.Platform.isMacOS) {
      return [
        PlatformMenu(
          label: "app_name".tr,
          menus: [
            const PlatformMenuItemGroup(
              members: [
                PlatformProvidedMenuItem(
                  type: PlatformProvidedMenuItemType.about,
                ),
              ]
            ),
            PlatformMenuItemGroup(
                members: [
                  PlatformMenuItem(
                      label: "menu.app_name.settings".tr,
                      onSelected: (){
                        showSettingsDialog(context);
                      }
                  ),
                  PlatformMenuItem(
                      label: "menu.app_name.github".tr,
                      onSelected: () async {
                        await openLink();
                      }
                  ),
                ]
            ),
            const PlatformMenuItemGroup(
              members: [
                PlatformProvidedMenuItem(
                  type: PlatformProvidedMenuItemType.quit,
                ),],
            )

          ],
        ),
        const PlatformMenu(
          label: 'View',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.toggleFullScreen,
            ),
          ],
        ),
        const PlatformMenu(
          label: 'Window',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.minimizeWindow,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.zoomWindow,
            ),
          ],
        ),
      ];
    } else {
      return [];
    }
  }
}

Future<void> showSettingsDialog(BuildContext context) async {
  SettingsModel? settings = await showMacosSheet<SettingsModel>(
    context: context,
    barrierDismissible: false,
    builder: (buildContext) => SettingsDialog(),
  );

  if(settings != null) {
    service.saveSettings(settings);
  }
}
