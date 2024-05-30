import 'package:geolocator/geolocator.dart';

class GeolocationUser {
  double? lat;
  double? long;
  String erro = "";


  Future<void> getPosition() async {
    // Seção de obtenção de posição
    try {
      Position positionUser = await _positionAtual();
      lat = positionUser.latitude;
      long = positionUser.longitude;
    } catch (e) {
      erro = e.toString();
    }
  }

  Future<Position> _positionAtual() async {
    LocationPermission locationPermission;
    // verifica se o GPS está disponível no dispositivo
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!locationServiceEnabled) {
      await Geolocator
          .openLocationSettings(); // Abre as configurações de localização
      // Se o serviço de localização estiver desativado, define a mensagem de erro
      // return Future.error('Por favor, habilite a localização no smartphone');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      // Se a permissão de localização for negada, solicita permissão ao usuário
      locationPermission = await Geolocator.requestPermission();
      //
      if (locationPermission == LocationPermission.denied) {
        // Se o usuário negar a permissão, define a mensagem de erro
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      // Se o usuário negar a permissão permanentemente, define a mensagem de erro
      return Future.error(
          'Você precisa autorizar o acesso à localização (Manualmente)');
    }

    return await Geolocator.getCurrentPosition(
      // desiredAccuracy: LocationAccuracy.bestForNavigation);
        desiredAccuracy: LocationAccuracy.high);

    // Usa o GPS com a máxima precisão possível. Isso ajudará a evitar o uso de dados da internet para obter a localização.
    // desiredAccuracy: LocationAccuracy.bestForNavigation);

    //

    // para saber a distancia em metros de um ponto a outro.
    // double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    // print("em metro $distanceInMeters");
  }
}
