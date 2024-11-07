import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_agent_core_dart/lite_agent_core.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:get/get.dart';
import 'capability_dialog.dart';
import '../controller/chat_controller.dart';
import '../model/model.dart';


class ChatPage extends StatelessWidget {
  ChatPage({super.key, required AgentPreviewModel agentPreview}) {
    chatController.agentPreview.value = agentPreview;
  }

  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    chatController.init();
    return Obx(()=> MacosScaffold(
      toolBar: ToolBar(
        title: Text(chatController.agentPreview.value.name),
        titleWidth: 150.0,
        leading: MacosTooltip(
          message: 'Toggle Sidebar',
          useMousePosition: false,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              size: 20.0,
            ),
            boxConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20,
              maxWidth: 48,
              maxHeight: 38,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
          ),
        ),
        actions: [
          ToolBarPullDownButton(
            label: 'More',
            icon: CupertinoIcons.ellipsis,
            tooltipMessage: 'More operations',
            items: [
              MacosPulldownMenuItem(
                label: 'Details',
                title: SizedBox(
                  width: 100,
                  child: Text("chat_page.more.details".tr)
                ),
                onTap: () async {
                  chatController.isDetailVisible.value = !chatController.isDetailVisible.value;
                },
              ),
              MacosPulldownMenuItem(
                label: 'Capability',
                title: Text("chat_page.more.capability".tr),
                onTap: () => showCapabilityDialog(context),
              ),
              const MacosPulldownMenuDivider(),
              MacosPulldownMenuItem(
                label: 'Delete',
                enabled: true,
                title: Text("chat_page.more.delete".tr, style: const TextStyle(color: MacosColors.systemRedColor),),
                onTap: () => showMacosAlertDialog(
                  context: context,
                  builder: (context) => MacosAlertDialog(
                    appIcon: const Icon(CupertinoIcons.delete),
                    title: Text("delete_dialog.title".tr),
                    message: Text(
                      "delete_dialog.message".tr,
                      textAlign: TextAlign.center,
                    ),
                    primaryButton: PushButton(
                      controlSize: ControlSize.large,
                      onPressed: () {
                        chatController.deleteAgent();
                        Navigator.of(context).pop();
                      },
                      child: Text("delete_dialog.delete".tr),
                    ),
                    secondaryButton: PushButton(
                      controlSize: ControlSize.large,
                      secondary: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("common.cancel".tr),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      children: [
            ContentArea(
              builder: (buildContext, scrollController) {
                chatController.setChatScrollController(scrollController);
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Obx(()=>ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          itemCount: chatController.chatMessageList.length,
                          itemBuilder: (context, index) {
                            return ChatBubble(agentMessage: chatController.chatMessageList[index]);
                          },
                        ),),
                      ),
                    ),
                    ResizablePane.noScrollBar(
                      minSize: 50,
                      startSize: 200,
                      resizableSide: ResizableSide.top,
                      child: ChatInputArea(
                        chatController: chatController,
                        onSend: (String text) {
                          String newText = text.trim();
                          if(newText.isNotEmpty) {
                            chatController.sendUserMessage(text);
                          }
                        }
                      ),
                    ),
                  ]
              );
            },
        ),
        if (chatController.isDetailVisible.value)
        ResizablePane(
          minSize: 0,
          startSize: 200,
          resizableSide: ResizableSide.left,
          maxSize: double.infinity,
          builder:  (buildContext, scrollController) {
            chatController.setDetailScrollController(scrollController);
            return Obx(()=>ListView.builder(
              reverse: true,
              controller: scrollController,
              itemCount: chatController.detailMessageList.length,
              itemBuilder: (context, index) {
                return DetailBubble(agentMessage: chatController.detailMessageList[index]);
              },
            ));
          },
        ),
      ],
    ));
  }

  Future<void> showCapabilityDialog(BuildContext context) async {
    AgentCapabilityModel? currentAgentCapability = chatController.getCurrentAgentCapability();

    AgentCapabilityModel? agentCapability = await showMacosSheet<AgentCapabilityModel>(
      context: context,
      barrierDismissible: false,
      builder: (buildContext) => CapabilityDialog(title: "capability_page.title.capability".tr, agentCapability: currentAgentCapability),
    );

    if(agentCapability != null) {
      if(currentAgentCapability !=null && ((currentAgentCapability.name != agentCapability.name) || (currentAgentCapability.type != agentCapability.type))) {
        AgentPreviewModel  newAgentPreview = AgentPreviewModel(type: agentCapability.type, id: chatController.agentPreview.value.id, name: agentCapability.name, updateTime: DateTime.now());
        chatController.updateAgentPreview(newAgentPreview);
      }
      chatController.updateCapability(agentCapability);
    }
  }

}

class ChatBubble extends StatelessWidget {
  final AgentMessageModel agentMessage;

  const ChatBubble({super.key, required this.agentMessage});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if(agentMessage.type == AgentMessageType.TEXT) {
      String message = agentMessage.message as String;
      Widget markdown = MarkdownBody(
        data: message,
        selectable: true,
        styleSheet: MarkdownStyleSheet.fromTheme(
          Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
          ),
        ),
      );
      children.add(markdown);
    } else if (agentMessage.type == AgentMessageType.CONTENT_LIST) {
      List<Content> contentList = List<Content>.from(agentMessage.message);
      for (int i = 0; i < contentList.length; i++) {
        Widget markdown = MarkdownBody(
          data: contentList[i].message,
          selectable: true,
          styleSheet: MarkdownStyleSheet.fromTheme(
            Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
              ),
            ),
          ),
        );
        children.add(markdown);
        if (i < contentList.length - 1) {
          Divider divider = Divider(color: MacosTheme.of(context).dividerColor);
          children.add(divider);
        }
      }
    }
    return Align(
      alignment: agentMessage.from == AgentRoleType.USER?Alignment.centerRight:Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.55,
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: agentMessage.from==AgentRoleType.USER?MacosTheme.of(context).primaryColor: MacosColors.systemGreenColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        ),
      ),
    );
  }
}

class DetailBubble extends StatelessWidget {
  final AgentMessageModel agentMessage;

  const DetailBubble({super.key, required this.agentMessage});

  @override
  Widget build(BuildContext context) {
    
    Map<String, Color> fromColorMap = {
      AgentRoleType.USER: MacosTheme.of(context).primaryColor,
      AgentRoleType.CLIENT: MacosColors.systemGrayColor,
      AgentRoleType.TOOL: MacosColors.systemOrangeColor,
      AgentRoleType.SYSTEM: MacosTheme.of(context).dividerColor,
      AgentRoleType.LLM: MacosColors.systemIndigoColor
    };
    Map<String, Color> agentToColorMap = {
      AgentRoleType.USER: MacosColors.systemGreenColor,
      AgentRoleType.CLIENT: MacosColors.systemGrayColor,
      AgentRoleType.TOOL: MacosColors.systemOrangeColor,
      AgentRoleType.SYSTEM: MacosTheme.of(context).dividerColor,
      AgentRoleType.LLM: MacosColors.systemIndigoColor
    };

    return Align(
      alignment: agentMessage.from == AgentRoleType.USER?Alignment.centerRight:Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.55,
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: agentMessage.from==AgentRoleType.AGENT?agentToColorMap[agentMessage.to]:fromColorMap[agentMessage.from],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SelectableText(
            const JsonEncoder.withIndent('  ').convert(agentMessage.toJson()),
            style: const TextStyle(color: MacosColors.white,fontSize: 10.0)
          ),
        ),
      ),
    );
  }
}

class ChatInputArea extends StatelessWidget {
  final ChatController chatController;
  final TextEditingController textController = TextEditingController();
  final void Function(String) onSend;

  ChatInputArea({super.key, required this.chatController, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MacosTheme.of(context).canvasColor,
      child: Column(
        children: [
          Expanded(
          child: Focus(
          autofocus: true,
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (keyEvent) {
                if(keyEvent is KeyDownEvent && (keyEvent.logicalKey == LogicalKeyboardKey.shiftLeft || keyEvent.logicalKey == LogicalKeyboardKey.shiftRight)) {
                  chatController.isShiftPressed = true;
                }
                if(keyEvent is KeyUpEvent && (keyEvent.logicalKey == LogicalKeyboardKey.shiftLeft || keyEvent.logicalKey == LogicalKeyboardKey.shiftRight)) {
                  chatController.isShiftPressed = false;
                }
                if (!chatController.isShiftPressed && keyEvent.logicalKey == LogicalKeyboardKey.enter) {
                  onSend(textController.text);
                  textController.clear();
                  chatController.isInputEmpty.value = textController.text.isEmpty;
                }
              },
              child: MacosTextField(
                decoration: BoxDecoration(
                  color: MacosTheme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(
                    color: MacosTheme.of(context).canvasColor,
                    width: 0,
                  ),
                ),
                textAlignVertical: TextAlignVertical.top,
                controller: textController,
                placeholder: "chat_page.text.placeholder".tr,
                maxLines: null,
                onChanged: (text) {
                  chatController.isInputEmpty.value = text.trim().isEmpty;
                },
              )
            )
          )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
            children: [
              //TODO 增加图片读取
              // IconButton(
              //   icon: const MacosIcon(
              //     CupertinoIcons.add_circled,
              //   ),
              //   onPressed: () => debugPrint('Upload'),
              // ),
              Expanded(child: Container()),
                Obx(()=>PushButton(
                  controlSize: ControlSize.large,
                  onPressed: chatController.isInputEmpty.value ? null : (){
                      onSend(textController.text);textController.clear();
                      chatController.isInputEmpty.value = textController.text.isEmpty;
                    },
                  child: Text("chat_page.send".tr),
              )),
            ],
          )
          ),
        ],
      )
    );
  }
}