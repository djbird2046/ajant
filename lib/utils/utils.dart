import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLink() async {
  String url = "app_name.link".tr;
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  }
}

bool isHttpOrHttpsUrl(String url) {
  const String urlPattern = r'^(https?):\/\/[^\s/$.?#].[^\s]*$';
  final bool result = RegExp(urlPattern, caseSensitive: false).hasMatch(url);
  return result;
}