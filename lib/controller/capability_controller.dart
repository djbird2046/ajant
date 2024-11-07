import 'package:get/get.dart';
import '../service/service.dart';
import '../model/model.dart';
import '../utils/utils.dart';

class CapabilityController extends GetxController {
  RxString displayType = "".obs;
  RxString tips = "".obs;
  RxBool errorTips = true.obs;

  void init() {
    tips.value = "";
  }

  AgentCapabilityModel? parse(String type, String name, String baseUrl, String apiKey, String model,  String temperature,  String maxTokens, String topP, String systemPrompt, String timeout) {
    String? tipsMessage = _check(type, name, baseUrl, apiKey, model, temperature, maxTokens, topP, systemPrompt);
    if(tipsMessage != null) {
      tips.value = tipsMessage;
      return null;
    } else {
      CapabilityModel capability = CapabilityModel(
          llmConfig: LLMConfigModel(
            baseUrl: baseUrl,
            apiKey: apiKey,
            model: model,
            temperature: double.parse(temperature),
            maxTokens: int.parse(maxTokens),
            topP: double.parse(topP),
          ),
          systemPrompt: systemPrompt,
      );
      AgentCapabilityModel agentCapability = AgentCapabilityModel(type: type, name: name, capability: capability);
      return agentCapability;
    }
  }

  String? _check(String type, String name, String baseUrl, String apiKey, String model,  String temperature,  String maxTokens, String topP, String systemPrompt) {

    errorTips.value = true;

    if(name.isEmpty) {
      return "capability_page.basic.name".tr + "capability_page.tips.empty_postfix".tr;
    }

    if(baseUrl.isEmpty) {
      return "capability_page.basic.baseUrl".tr + "capability_page.tips.empty_postfix".tr;
    }

    if(!isHttpOrHttpsUrl(baseUrl)) {
      return "capability_page.basic.baseUrl".tr + "capability_page.tips.url_postfix".tr;
    }

    if(apiKey.isEmpty) {
      return "capability_page.basic.apikey".tr + "capability_page.tips.empty_postfix".tr;
    }

    if(model.isEmpty) {
      return "capability_page.basic.model".tr + "capability_page.tips.empty_postfix".tr;
    }

    if(maxTokens.isEmpty) {
      return "capability_page.basic.max_tokens".tr + "capability_page.tips.empty_postfix".tr;
    }

    errorTips.value = false;
    return null;
  }

  Future<String?> test(String baseUrl, String apiKey) async {
    errorTips.value = true;
    if(baseUrl.isEmpty) {
      return "capability_page.basic.baseurl".tr + "capability_page.tips.empty_postfix".tr;
    }

    if(!isHttpOrHttpsUrl(baseUrl)) {
      return "capability_page.basic.baseurl".tr + "capability_page.tips.url_postfix".tr;
    }

    if(apiKey.isEmpty) {
      return "capability_page.basic.apikey".tr + "capability_page.tips.empty_postfix".tr;
    }

    // if(model.isEmpty) {
    //   return "capability_page.basic.model".tr + "capability_page.tips.empty_postfix".tr;
    // }

    bool isTestPass = await service.testLLMConfig(baseUrl, apiKey);

    errorTips.value = !isTestPass;
    if(isTestPass) {
      return "capability_page.basic.test.success".tr;
    } else {
      return "capability_page.basic.test.failure".tr;
    }
  }
}