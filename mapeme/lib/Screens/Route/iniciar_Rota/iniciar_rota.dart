import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../BD/table_point_interest.dart';
import '../../../Localization/google_maps_location.dart';
import '../../../Models/point_interest.dart';
import '../../Widgets/text_button.dart';
import '../../Widgets/utils/informativo.dart';
import '../connection_google_maps/google_maps_route_point.dart';

import 'package:geolocator/geolocator.dart';

class IniciarRota extends StatefulWidget {
  final int idRoute;
  final String nameRoute;

  const IniciarRota(
      {super.key, required this.idRoute, required this.nameRoute});

  @override
  State<IniciarRota> createState() => _IniciarRotaState();
}

class _IniciarRotaState extends State<IniciarRota> {
  bool isLoading = false;

  //
  Future<void> carregarPontosDeInteresse() async {
    // Recebe a intancia da classe GeolocationUserGoogleMaps
    GeolocationUserGoogleMaps googleMapsGeolocationUser =
        GeolocationUserGoogleMaps();
    // Muda o valor da variavel para aparecer o circularProgress
    setState(() {
      isLoading = true;
    });

    try {
      // // Recupera a instancia do bd
      var bdPoint = GetIt.I.get<ManipuTablePointInterest>();
      // captura as latitudes e longitudes dos pontos de interesse ligados a rota
      List<PointInterest> pLatLong =
          await bdPoint.getPointInterestLatLog(widget.idRoute);
      //

      // Ponto de inicio
      List<PointInterest> pointInicio =
          await bdPoint.getPointInterestStatus();

      // // captura a gelocalização do usuário
      // Chama a função responsavel pela a geolocalização
      await googleMapsGeolocationUser.getPosition();

      for (int i = 0; i < pLatLong.length; i++) {
        // if (pointInicio[0].latitude != pLatLong[i].latitude && pointInicio[0].longitude != pLatLong[i].longitude){

        // }
        double distanceInMeters = Geolocator.distanceBetween(
            pointInicio[0].latitude,
            pointInicio[0].longitude,
            pLatLong[i].latitude,
            pLatLong[i].longitude);

        pLatLong[i].distancia = distanceInMeters;
        debugPrint(
            "distancia da localização do usuario ao ponto ${pLatLong[i].name} é : ${pLatLong[i].distancia}");
      }

      // Ordenar a lista por distancia em ordem crescente
      pLatLong.sort((a, b) => a.distancia.compareTo(b.distancia));

      
      // Chama a função para carregar os pontos de interesse da rota
      googleMapsGeolocationUser.loadPointsRoute(pLatLong: pLatLong);

      // se dê algum erro
    } catch (e) {
      Aviso.showSnackBar(
          context, 'Erro ao carregar os pontos de interesse: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    // Fecha a tela
    _navegaProxPage(googleMapsGeolocationUser);
  }

  // navega para a página de mostrar o mapa
  _navegaProxPage(GeolocationUserGoogleMaps googleMapsGeolocationUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PagePointsRoute(
          nameRoute: widget.nameRoute,
          googleMapsGeolocationUser: googleMapsGeolocationUser,
          // pLatLong: pLatLong,
        ),
      ),
    );
  }

  //

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : carregarPontosDeInteresse,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 63, 6),
        elevation: 10,
        minimumSize: const Size.fromHeight(50),
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
