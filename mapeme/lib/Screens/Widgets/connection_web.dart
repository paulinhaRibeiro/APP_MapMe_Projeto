import 'package:flutter/material.dart';
import 'package:mapeme/Screens/Widgets/text_button.dart';
// para ir para a url
import 'package:url_launcher/url_launcher.dart';

class WebPageSite extends StatelessWidget {
  final String lat;
  final String long;
  const WebPageSite({super.key, required this.lat, required this.long});

  // Função para lançar a URL usando o url_launcher
  Future<void> _lauchLink(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url, forceWebView: false, forceSafariVC: false);
    } else {
      debugPrint("Deu errado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 63, 6),
        elevation: 10,
        minimumSize: const Size.fromHeight(55),
      ),
      onPressed: () =>
          _lauchLink("https://www.google.com/maps/search/$lat,$long/"),
      icon: const Icon(
        Icons.map_outlined,
        color: Colors.white,
      ),
      label: const ScreenTextButtonStyle(text: "Ver no Mapa"),
    );
  }
}
