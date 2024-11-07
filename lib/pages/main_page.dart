import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';
import '../controller/main_controller.dart';
import '../model/model.dart';
import '../utils/utils.dart';
import 'capability_dialog.dart';
import 'platform_menus.dart';
import 'chat_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final MainController mainController = Get.put(MainController());
  late final searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mainController.init();
    return PlatformMenuBar(
      menus: menuBarItems(context),
        child: MacosWindow(
        sidebar: Sidebar(
          top: Obx(() => Row(
            children: [
              Expanded(
                child: MacosSearchField(
                  placeholder: "main_page.search.placeholder".tr,
                  controller: searchFieldController,
                  onResultSelected: (result) {
                    mainController.searchAgent(result.searchKey);
                  },
                  results: mainController.searchHistoryList
                      .map((String searchHistory)=> SearchResultItem(searchHistory))
                      .toList(),
                  maxLines: 1,
                )
              ),
              IconButton(
                icon: const MacosIcon(CupertinoIcons.add_circled_solid),
                onPressed: () => showCapabilityDialog(context),
              )
            ],
          )),
          minWidth: 200,
          builder: (context, scrollController) => Obx(() {
              return SidebarItems(
              currentIndex: mainController.currentIndex.value<0?0:mainController.currentIndex.value,
              onChanged: (index) {
                mainController.selectedAgent(index);
              },
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              items: mainController.agentPreviewList
                  .map((AgentPreviewModel agentPreviewModel){
                    MacosIcon leadingIcon = const MacosIcon(CupertinoIcons.question_circle);
                    if(agentPreviewModel.type == AgentType.simple) {
                      leadingIcon = const MacosIcon(CupertinoIcons.bubble_left);
                    } else if(agentPreviewModel.type == AgentType.session) {
                      leadingIcon = const MacosIcon(CupertinoIcons.bubble_left_bubble_right);
                    }
                    return SidebarItem(
                      leading: leadingIcon,
                      label: Text(agentPreviewModel.name, style: const TextStyle(fontSize:15),
                      maxLines: 1),
                    );
                  })
                  .toList(),
            );}
          ),
          bottom: MacosListTile(
            leading: const MacosIcon(CupertinoIcons.link),
            title: Text("app_name".tr),
            subtitle: Text("app_name.subtitle".tr),
            onClick: () async {
              await openLink();
            },
          ),
        ),
        child: CupertinoTabView(builder: (_) => Obx((){
          if(mainController.agentPreviewList.length <= mainController.currentIndex.value || mainController.currentIndex.value < 0 ) {
            return Column(
              children: [Expanded(
              child: Center(
                child: Text(
                  "app_name".tr,
                  style: TextStyle(fontSize: 32, color: MacosTheme.of(context).dividerColor),
                ),
              ),
            )]);
          }
          return ChatPage(agentPreview: mainController.agentPreviewList[mainController.currentIndex.value]);
        })),
      ),
    );
  }

  Future<void> showCapabilityDialog(BuildContext context) async {
    AgentCapabilityModel? agentCapability = await showMacosSheet<AgentCapabilityModel>(
      context: context,
      barrierDismissible: false,
      builder: (buildContext) => CapabilityDialog(title: "capability_page.title.add_agent".tr),
    );

    if(agentCapability != null) {
      await mainController.createAgent(agentCapability);
    }
  }
}

