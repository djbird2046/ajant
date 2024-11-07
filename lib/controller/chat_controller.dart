import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lite_agent_core_dart/lite_agent_core.dart';
import '../model/model.dart';
import '../service/service.dart';

class ChatController extends GetxController {
  RxList<AgentMessageModel> detailMessageList = <AgentMessageModel>[].obs;
  RxList<AgentMessageModel> chatMessageList = <AgentMessageModel>[].obs;
  Rx<bool> isInputEmpty = true.obs;
  Rx<bool> isTaskDone = true.obs;
  Rx<bool> isDetailVisible = false.obs;
  bool isShiftPressed = false;
  Rx<AgentPreviewModel> agentPreview = AgentPreviewModel(type: "", id: "", name: "", lastMessage: "", updateTime: DateTime.now()).obs;
  ScrollController? chatScrollController;
  ScrollController? detailScrollController;

  bool hasInit = false;

  void init() {
    List<AgentMessageModel> agentMessageList = service.loadAgentMessageList(agentPreview.value.id);
    detailMessageList.value = agentMessageList.reversed.toList();
    List<AgentMessageModel> chatUserMessageList = agentMessageList.where((agentMessage)=>(agentMessage.from == AgentRoleType.USER || agentMessage.to == AgentRoleType.USER)).toList().reversed.toList();
    //TODO 从源头控制SessionId与对应的AgentMessage的SessionId一致
    // if(service.currentSessionId.isNotEmpty) {
    //   chatMessageList.value = chatUserMessageList.where((agentMessage)=>agentMessage.sessionId == service.currentSessionId).toList();
    // } else {
      chatMessageList.value = chatUserMessageList;
    // }

    // Future.delayed(const Duration(milliseconds: 100), (){
    //   _scrollToBottomDirectly(chatScrollController);
    //   _scrollToBottomDirectly(detailScrollController);
    // });
  }

  void setChatScrollController(ScrollController scrollController) {
    chatScrollController = scrollController;
  }

  void setDetailScrollController(ScrollController scrollController) {
    detailScrollController = scrollController;
  }
  
  // void _scrollToBottomDirectly(ScrollController? scrollController) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (scrollController != null && scrollController.hasClients) {
  //       scrollController.jumpTo(scrollController.position.maxScrollExtent);
  //     }
  //   });
  // }
  //
  // void _scrollToBottomWithAnimation(ScrollController? scrollController) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (scrollController != null && scrollController.hasClients) {
  //       scrollController.animateTo(
  //         scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  AgentCapabilityModel? getCurrentAgentCapability() {
    return service.currentAgentCapability;
  }

  Future<void> updateAgentPreview(AgentPreviewModel agentPreview) async {
    this.agentPreview.value = agentPreview;
    await service.updateAgentPreview(agentPreview);
  }

  Future<void> deleteAgent() async {
    await service.deleteAgent();
  }

  void listen(String sessionId, AgentMessageModel agentMessage) {
    detailMessageList.insert(0, agentMessage);
    // _scrollToBottomWithAnimation(detailScrollController);
    if(sessionId == agentMessage.sessionId && (agentMessage.from == AgentRoleType.USER || agentMessage.to == AgentRoleType.USER)) {
      chatMessageList.insert(0, agentMessage);
      // _scrollToBottomWithAnimation(chatScrollController);
    }
  }

  Future<void> sendUserMessage(String userMessage) async {
    List<UserMessageModel> userMessageList = [UserMessageModel(type: UserMessageModelType.text, message: userMessage)];
    if(service.currentAgentCapability != null && service.currentAgentCapability!.type == AgentType.simple) {
      await service.startSimple(userMessageList, listen);
    } else if(service.currentAgentCapability != null && service.currentAgentCapability!.type == AgentType.session) {
      await service.startSession(userMessageList, listen);
    }
  }

  // Future<void> continueSubscribe() async {
  //   service.continueSubscribe(agentPreview.value.id, listen);
  // }

  Future<void> updateCapability(AgentCapabilityModel agentCapability) async {
    await service.updateAgentCapability(agentCapability);
  }
}