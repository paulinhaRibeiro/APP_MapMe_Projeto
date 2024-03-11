import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationUser extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = "";

  GeolocationUser() {
    getPosition();
  }

  getPosition() async {
    try {
      Position positionUser = await _positionAtual();
      lat = positionUser.latitude;
      long = positionUser.longitude;
    } catch (e) {
      erro = e.toString();
    }
    notifyListeners();
  }

  Future<Position> _positionAtual() async {
    LocationPermission locationPermission;
    // bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    // if (!locationServiceEnabled) {
    //   // Se o serviço de localização estiver desativado, define a mensagem de erro
    //   return Future.error('Por favor, habilite a localização no smartphone');
    // }

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
      return Future.error('Você precisa autorizar o acesso à localização (Manualmente)');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // para saber a distancia em metros de um ponto a outro.
    // double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    // print("em metro $distanceInMeters");
  }
}
