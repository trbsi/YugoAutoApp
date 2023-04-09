import 'package:url_launcher/url_launcher.dart';

class WebviewCoreService {
  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
