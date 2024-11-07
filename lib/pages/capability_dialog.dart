import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';
import '../controller/capability_controller.dart';
import '../model/model.dart';

class CapabilityDialog extends StatelessWidget {
  final CapabilityController capabilityController = Get.put(CapabilityController());

  final String title;
  final tabController = MacosTabController(initialIndex: 0, length: 2);
  final TextEditingController agentNameTextController = TextEditingController();
  final TextEditingController baseUrlTextController = TextEditingController();
  final TextEditingController apiKeyTextController = TextEditingController();
  final TextEditingController modelTextController = TextEditingController();
  final TextEditingController temperatureTextController = TextEditingController(text: "0.0");
  final TextEditingController maxTokensTextController = TextEditingController();
  final TextEditingController topPTextController = TextEditingController(text: "1.0");
  final TextEditingController timeoutTextController = TextEditingController(text: "3600");

  final TextEditingController systemPromptTextController = TextEditingController();

  final AgentCapabilityModel? agentCapability;

  CapabilityDialog({super.key, required this.title, this.agentCapability});

  void init(Map<String, String> typePopupMenuMap) {
    if(agentCapability != null) {
      Map<String, String> reversedTypeMap = typePopupMenuMap.map((key, value) => MapEntry(value, key));
      capabilityController.displayType.value = reversedTypeMap[agentCapability!.type]!;

      agentNameTextController.text = agentCapability!.name;
      baseUrlTextController.text = agentCapability!.capability.llmConfig.baseUrl;
      apiKeyTextController.text = agentCapability!.capability.llmConfig.apiKey;
      modelTextController.text = agentCapability!.capability.llmConfig.model;
      temperatureTextController.text = agentCapability!.capability.llmConfig.temperature.toString();
      maxTokensTextController.text = agentCapability!.capability.llmConfig.maxTokens.toString();
      topPTextController.text = agentCapability!.capability.llmConfig.topP.toString();
      systemPromptTextController.text = agentCapability!.capability.systemPrompt;
    } else {
      capabilityController.displayType.value = typePopupMenuMap.keys.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> typePopupMenuMap = {
      "capability_page.basic.type.simple".tr: AgentType.simple,
      "capability_page.basic.type.session".tr: AgentType.session
    };
    init(typePopupMenuMap);
    capabilityController.init();
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
                  title,
                  style: MacosTheme.of(context).typography.headline,
                ),
              ),
              Divider(color: MacosTheme.of(context).dividerColor,),
              Container(height: 4),
              Expanded(
                child: ContentArea(
                  builder: (context, _) {
                    return MacosTabView(
                      controller: tabController,
                      tabs: [
                        MacosTab(label: "capability_page.basic".tr),
                        MacosTab(label: "capability_page.system_prompt".tr),
                        // MacosTab(label: "capability_page.tools".tr),
                      ],
                      children: [
                        _buildBasicTable(context, typePopupMenuMap),
                        _buildSystemPrompt(context),
                        // const Center(child: Text('Coming soon...')),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Obx(() =>Expanded(
                    child:  Text(
                      capabilityController.tips.value,
                      style: TextStyle(color: capabilityController.errorTips.value? MacosColors.systemRedColor : MacosColors.systemGreenColor),
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
                      AgentCapabilityModel? agentCapability = capabilityController.parse(
                          typePopupMenuMap[capabilityController.displayType.value]!,
                          agentNameTextController.text,
                          baseUrlTextController.text,
                          apiKeyTextController.text,
                          modelTextController.text,
                          temperatureTextController.text,
                          maxTokensTextController.text,
                          topPTextController.text,
                          systemPromptTextController.text,
                          timeoutTextController.text
                      );

                      if(agentCapability != null) {
                        return Navigator.of(context).pop<AgentCapabilityModel>(agentCapability);
                      }
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

  Widget _buildBasicTable(BuildContext context, Map<String, String> typePopupMenuMap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: SingleChildScrollView(
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 48,
                          child: Row(
                            children: [
                              Text("capability_page.basic.type".tr, style: MacosTheme.of(context).typography.body,),
                              const Text("*", style: TextStyle(color: MacosColors.systemRedColor),),
                            ],
                          )),
                      const SizedBox(width: 8),
                      Obx(()=>MacosPopupButton<String>(
                        value: capabilityController.displayType.value,
                          onChanged: (String? newValue) {
                            capabilityController.displayType.value = newValue??"";
                          },
                        items: typePopupMenuMap.keys.map<MacosPopupMenuItem<String>>((String value) {
                          return MacosPopupMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 48,
                              child: Row(
                                children: [
                                  Text("capability_page.basic.name".tr, style: MacosTheme.of(context).typography.body,),
                                  const Text("*", style: TextStyle(color: MacosColors.systemRedColor),),
                                ],
                              )),
                          // const SizedBox(width: 8),
                          Expanded(
                            child: MacosTextField(
                              placeholder: "capability_page.basic.name.placeholder".tr,
                              controller: agentNameTextController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: MacosTheme.of(context).dividerColor,),
            _buildTableRow(context, "capability_page.basic.baseurl".tr, "capability_page.basic.baseurl.placeholder".tr, baseUrlTextController, isRequired: true, inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"[^A-Za-z0-9\-._~:/?#\[\]@!$&'()*+,;=%]"))]),
            _buildTableRow(context, "capability_page.basic.apikey".tr, "capability_page.basic.apikey.placeholder".tr, isRequired: true, apiKeyTextController),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Container()),
                PushButton(
                  controlSize: ControlSize.regular,
                  child: Text("capability_page.basic.test".tr),
                  onPressed: () async {
                    capabilityController.tips.value = "";
                    String? tips = await capabilityController.test(
                        baseUrlTextController.text,
                        apiKeyTextController.text
                    );
                    if(tips != null) {
                      capabilityController.tips.value = tips;
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 16),
            _buildTableRow(context, "capability_page.basic.model".tr, "capability_page.basic.model.placeholder".tr, isRequired: true, modelTextController),
            _buildTableRow(context, "capability_page.basic.temperature".tr, "capability_page.basic.temperature.placeholder".tr, temperatureTextController, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(0(\.\d*)?|1(\.0*)?)$'))]),
            _buildTableRow(context, "capability_page.basic.max_tokens".tr, "capability_page.basic.max_tokens.placeholder".tr, maxTokensTextController, isRequired: true, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            _buildTableRow(context, "capability_page.basic.top_p".tr, "capability_page.basic.top_p.placeholder".tr, topPTextController, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(0(\.\d*)?|1(\.0*)?)$'))]),
            if(typePopupMenuMap[capabilityController.displayType.value] == AgentType.session)...[
              Divider(color: MacosTheme.of(context).dividerColor,),
              // const SizedBox(height: 24),
              _buildTableRow(context, "capability_page.basic.session_timeout".tr, "capability_page.basic.session_timeout.placeholder".tr, timeoutTextController, isRequired: false, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            ],
          ],
        ),)
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, String item, String placeholder, TextEditingController textController,{bool isRequired = false, List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Row(
              children: [
                Text(item, style: MacosTheme.of(context).typography.body,),
                Text(isRequired? "*": "", style: const TextStyle(color: MacosColors.systemRedColor),),
              ],
            )
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MacosTextField(
              placeholder: placeholder,
              controller: textController,
              inputFormatters: inputFormatters,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemPrompt(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
            children: [
              Expanded(
                child: MacosTextField(
                  controller: systemPromptTextController,
                  placeholder: "capability_page.system_prompt.text.placeholder".tr,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  onChanged: (text) {
                    // debugPrint(text);
                  },
                ),
              ),
            ]
        )
    );
  }
}
