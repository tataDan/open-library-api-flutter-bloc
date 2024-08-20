import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlForBook(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchUrlForLanguageCodes(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
