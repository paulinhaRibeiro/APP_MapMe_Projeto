import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Localization/google_maps_location.dart';
import '../../Models/point_interest.dart';

final appKeyViewMap = GlobalKey();

class ViewMapLocation extends StatelessWidget {
  final GeolocationUserGoogleMaps googleMapsGeolocationUser;

  final PointInterest point;

  const ViewMapLocation({super.key, required this.point, required this.googleMapsGeolocationUser});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKeyViewMap,
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: Text(point.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            // Latitude e Longitude para ele centralizar o mapa
            initialCameraPosition: CameraPosition(
              // Alvo da lat e long
              target:
                  LatLng(point.latitude, point.longitude),
              zoom: 18,
            ),
            // controle de mais e menos
            zoomControlsEnabled: true,
            // Tipo do mapa
            mapType: MapType.hybrid,
            // Ativa o botão para mostrar a localização do usuário
            myLocationEnabled: true,
            // quando o mapa for criado chama o onMapCreated responsavel por movimentar o mapa, add e remover marcadores,
            // para controlar todas as informações que vai exibir no mapa
            onMapCreated: googleMapsGeolocationUser.onMapCreated,
            markers: googleMapsGeolocationUser.markers,
            
            
          ),

          Positioned(
            top: 9,
            left: 8,
            child: FloatingActionButton(
              mini: true,
              tooltip: "Foco: Ponto Inicial",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2), // Ajuste aqui para bordas arredondadas
              ),
              backgroundColor: Colors.white70,
              onPressed:
                googleMapsGeolocationUser.moveToFirstMarker
              ,
              child: Image.asset(
                    'assets/images_geral/icons_route/point_inicio.png',
                    height: 30, //17% da altura total da tela //height: 130,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
