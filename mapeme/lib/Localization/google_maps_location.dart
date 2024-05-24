import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapeme/Localization/geolocation.dart';

import '../Models/point_interest.dart';
import '../Screens/Route/connection_google_maps/page_route_point.dart';
import '../Screens/Route/connection_google_maps/point_details_google_maps.dart';
import '../Screens/Route/iniciar_Rota/model_point_lat_long_route.dart';
import '../Screens/Widgets/view_map_location.dart';

class GeolocationUserGoogleMaps {
  String erro = "";
  GeolocationUser geolocationUser = GeolocationUser();

  late GoogleMapController _mapsController;

  // Marcadores - conj de marcadores
  Set<Marker> markers = <Marker>{};

  // linha entre os point
  Set<Polyline> polyline = <Polyline>{};

  List<LatLng> points = [];

  
  

  // pontos de interesse da rota
  // late List<PointOfInterestLatLong> pLatLong;

  get mapsController => _mapsController;

  // função responsavel por carregar os marcadores
  loadPointsRoute(
      {List<PointOfInterestLatLong>? pLatLong, PointInterest? point}) async {
    String iconImg = 'assets/images_geral/icons_route/point_inicio.png';

    if (pLatLong != null) {
      for (int i = 0; i < pLatLong.length; i++) {
        if (i == 0) {
          iconImg = 'assets/images_geral/icons_route/point_inicio.png';
        } else if (i == (pLatLong.length - 1)) {
          iconImg = 'assets/images_geral/icons_route/point_destino.png';
        } else {
          if (pLatLong[i].typePointInterest != "TIPO NÃO IDENTIFICADO") {
            iconImg = 'assets/images_geral/icons_route/type_point.png';
          } else {
            iconImg = 'assets/images_geral/icons_route/point.png';
          }
        }

        // Add os valores ao marcador
        markers.add(
          Marker(
            markerId: MarkerId(pLatLong[i].id.toString()),
            position: LatLng(pLatLong[i].latitude, pLatLong[i].longitude),
            icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(),
              iconImg,
            ),
            infoWindow: InfoWindow(
                title: pLatLong[i].name,
                snippet: pLatLong[i].typePointInterest.toLowerCase()),
            onTap: () => {
              showModalBottomSheet(
                context: appKey.currentState!.context,
                builder: (context) =>
                    PointDetailsGoogleMaps(pLatLong: pLatLong[i]),
              )
            },
          ),
        );
        // end Marcador

        // add os points para mostrar a linha ligando os pontos
        points.add(LatLng(pLatLong[i].latitude, pLatLong[i].longitude));

      }

      polyline.add(
          Polyline(
            polylineId: PolylineId(pLatLong[0].id.toString()),
            points: points,
            color: const Color(0xFF220707),
            width: 5,
            patterns: [
              PatternItem.dash(30), // Comprimento do traço
              PatternItem.gap(10),  // Comprimento do espaço entre os traços
            ],
          ),
        );
    } else if (point != null) {
      markers.add(
        Marker(
          markerId: MarkerId(point.id.toString()),
          position: LatLng(point.latitude, point.longitude),
          icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            iconImg,
          ),
          infoWindow: InfoWindow(
              title: point.name,
              snippet: point.typePointInterest.toLowerCase()),
          onTap: () => {
            showModalBottomSheet(
              context: appKeyViewMap.currentState!.context,
              builder: (context) => PointDetailsGoogleMaps(point: point),
            )
          },
        ),
      );
    }
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    _init();
  }

  Future<void> _init() async {
    await getPosition();
  }

  Future<void> getPosition() async {
    // Seção de obtenção de posição e controle do google maps
    try {
      await geolocationUser.getPosition();

      _mapsController.animateCamera(CameraUpdate.newLatLng(
          LatLng(geolocationUser.lat!, geolocationUser.long!)));
    } catch (e) {
      erro = e.toString();
    }
  }
}
