import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Localization/google_maps_location.dart';

final appKey = GlobalKey();

class PagePointsRoute extends StatelessWidget {
  final GeolocationUserGoogleMaps googleMapsGeolocationUser;
  const PagePointsRoute(
      {super.key, required this.googleMapsGeolocationUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKey,
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Mapa"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: GoogleMap(
        // Latitude e Longitude para ele centralizar o mapa
        initialCameraPosition: CameraPosition(
          // Alvo da lat e long
          target:
              LatLng(googleMapsGeolocationUser.geolocationUser.lat!, googleMapsGeolocationUser.geolocationUser.long!),
          zoom: 18,
        ),
        // controle de mais e menos
        zoomControlsEnabled: true,
        // Tipo do mapa
        mapType: MapType.hybrid,
        // Botão para mostra a localização
        myLocationEnabled: true,
        
        // quando o mapa for criado chama o onMapCreated responsavel por movimentar o mapa, add e remover marcadores,
        // para controlar todas as informações que vai exibir no mapa
        onMapCreated: googleMapsGeolocationUser.onMapCreated,
        markers: googleMapsGeolocationUser.markers,
        polylines: googleMapsGeolocationUser.polyline,
      ),
    );
  }
}

