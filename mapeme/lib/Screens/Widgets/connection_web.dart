import 'package:flutter/material.dart';
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
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * .50,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color.fromARGB(255, 195, 195, 195)),
            image: const DecorationImage(
              image: AssetImage('assets/images_geral/map_img.png'),
              fit: BoxFit.cover,
            
            ),
          ),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 10,
              // backgroundColor: Colors.white.withOpacity(0.5),
            ),
            onPressed: () =>
                _lauchLink("https://www.google.com/maps/search/$lat,$long/"),
            icon: const Icon(Icons.link),
            label: const Text("Visualizar"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Latitude:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    lat,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 88, 88, 88),
                    ),
                  ),
                ),
                const Text(
                  "Longitude:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    long,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 88, 88, 88),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}