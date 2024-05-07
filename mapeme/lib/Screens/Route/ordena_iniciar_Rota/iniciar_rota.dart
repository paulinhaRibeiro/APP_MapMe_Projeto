// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// Pra ordenar com base na distância
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../BD/table_point_interest.dart';
import '../../../Localization/geolocation.dart';
import '../../Widgets/text_button.dart';
import '../../Widgets/utils/informativo.dart';
import 'model_point_lat_long_route.dart';

class IniciarRota extends StatefulWidget {
  final int idRoute;

  const IniciarRota({super.key, required this.idRoute});

  @override
  State<IniciarRota> createState() => _IniciarRotaState();
}

class _IniciarRotaState extends State<IniciarRota> {
  late List<PointOfInterestLatLong> pLatLong;
  bool isLoading = false;

  Future<void> _openGoogleMaps(GeolocationUser geolocationUser,
      List<PointOfInterestLatLong> pontosInteresse) async {
    // final url =
    //     'https://www.google.com/maps/dir/${pontosInteresse.map((p) => '${p.latitude},${p.longitude}').join('/')}';

//

    // Da localização do usuário (origin) ao último ponto (destination)
    String origin = '${geolocationUser.lat},${geolocationUser.long}';
    String destination =
        '${pontosInteresse.last.latitude},${pontosInteresse.last.longitude}';

    // especifica os pontos intermediários (waypoints) que a rota deve passar.
    String waypointsString = pontosInteresse
        .map((p) => '${p.latitude},${p.longitude}')
        .take(pontosInteresse.length - 1) // Remove o último elemento
        .join('|'); // Pule o ponto de partida na lista de waypoints

    //

    // Ponto de origem é o primeiro ponto cadastrado
    // String origin =
    //     '${pontosInteresse.first.latitude},${pontosInteresse.first.longitude}';
    // String destination =
    //     '${pontosInteresse.last.latitude},${pontosInteresse.last.longitude}';

    // String waypointsString = pontosInteresse
    //     .map((p) => '${p.latitude},${p.longitude}')
    //     .skip(1)
    //     .join('|'); // Pule o ponto de partida na lista de waypoints

    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&waypoints=$waypointsString';

    debugPrint(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // ignore: use_build_context_synchronously
      Aviso.showSnackBar(context, 'Não foi possível abrir o Google Maps.');
    }
  }

  // Função para ordenar os pontos com base na distancia
  Future<List<PointOfInterestLatLong>> ordenarPontosDeInteresse(
      pontoIniciaLatitude,
      pontoIniciaLongitude,
      List<PointOfInterestLatLong> pontos) async {
    // recebe as distancias
    double distancia = 0;
    try {
      final List<PointOfInterestLatLong> pontosComDistancia = [];
      for (var ponto in pontos) {
        // final distancia = Geolocator.distanceBetween(
        //   pontoIniciaLatitude,
        //   pontoIniciaLongitude,
        //   ponto.latitude,
        //   ponto.longitude,
        // );
        distancia = Geolocator.distanceBetween(
          pontoIniciaLatitude,
          pontoIniciaLongitude,
          ponto.latitude,
          ponto.longitude,
        );
        // Adiciona a distância calculada ao ponto atual.
        ponto.distancia = distancia;
        // Adiciona o ponto atual a lista pontosComDistancia.
        pontosComDistancia.add(ponto);
      }
      // Ordena a lista pontosComDistancia com base nas distâncias calculadas
      pontosComDistancia.sort((a, b) => a.distancia.compareTo(b.distancia));
      return pontosComDistancia;
    } catch (e) {
      debugPrint('Erro ao ordenar os pontos de interesse: $e');
      throw 'Erro ao ordenar os pontos de interesse.';
    }
  }

  //
  Future<void> _carregarPontosDeInteresse() async {
    // Muda o valor da variavel para aparecer o circularProgress
    setState(() {
      isLoading = true;
    });

    try {
      // Recupera a instancia do bd
      var bdPoint = GetIt.I.get<ManipuTablePointInterest>();
      // captura as latitudes e longitudes dos pontos de interesse ligados a rota
      pLatLong = await bdPoint.getPointInterestLatLog(widget.idRoute);
      //

      // captura a gelocalização do usuário
      GeolocationUser geolocationUser = GeolocationUser();
      // Chama a função responsavel pela a geolocalização
      await geolocationUser.getPosition();
      //

      // Chama a função para abrir o google maps
      // await _openGoogleMaps(geolocationUser, pLatLong);
      // //

      // Chama a função para ordenar os pontos de interesse
      final pontosInteresse = await ordenarPontosDeInteresse(
          geolocationUser.lat, geolocationUser.long, pLatLong);
      //
      // Chama a função para abrir o google maps
      await _openGoogleMaps(geolocationUser, pontosInteresse);
      //

      //
      // debugPrint('Pontos de interesse ordenados:');
      // for (var p in pontosInteresse) {
      //   debugPrint(
      //       '${p.name} Latitude: ${p.latitude}, Longitude: ${p.longitude}, Distância: ${p.distancia}');
      // }

      // se dê algum erro
    } catch (e) {
      Aviso.showSnackBar(
          context, 'Erro ao carregar os pontos de interesse: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : _carregarPontosDeInteresse,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 63, 6),
        elevation: 10,
        minimumSize: const Size.fromHeight(55),
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                ScreenTextButtonStyle(text: "Iniciar Rota"),
              ],
            ),
    );
  }
}
