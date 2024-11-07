import 'package:get/get.dart';
import '../service/service.dart';
import '../model/model.dart';

class MainController extends GetxController {

  RxList<AgentPreviewModel> agentPreviewList = <AgentPreviewModel>[].obs;
  RxList<String> searchHistoryList = <String>[].obs;
  Rx<int> currentIndex = (-1).obs; // -1 for not select any item

  Future<void> init() async {
    agentPreviewList.value = await service.getAgentPreviewList();
    searchHistoryList.value = agentPreviewList.map((agentPreview)=>agentPreview.name).toList();

    service.addAgentPreviewListListener(listen);
  }

  void listen(List<AgentPreviewModel> agentPreviewList) {
    this.agentPreviewList.value = agentPreviewList;
    searchHistoryList.value = agentPreviewList.map((agentPreview)=>agentPreview.name).toList();
  }

  Future<void> searchAgent(String searchHistory) async {
    int index = agentPreviewList.indexWhere((AgentPreviewModel agentPreview) => agentPreview.name == searchHistory);
    agentPreviewList[index].updateTime = DateTime.now();
    agentPreviewList.sort((a, b)=>b.updateTime.compareTo(a.updateTime));
    currentIndex.value = 0;
  }

  Future<void> selectedAgent(int selectedIndex) async {
    currentIndex.value = selectedIndex;
    service.selectAgent(agentPreviewList[selectedIndex].id);
  }

  Future<void> createAgent(AgentCapabilityModel agentCapability) async {
    await service.addAgent(agentCapability);
    currentIndex.value = 0;
  }
}