import 'package:geolocator/geolocator.dart';

Future<Position?> obterLocalizacaoAtual() async {
  LocationPermission locationPermission;
  bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!locationServiceEnabled) {
    print('Por favor, habilite a localização no smartphone');
    return null;
  }

  locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      print('Você precisa autorizar o acesso à localização');
      return null;
    }
  }

  if (locationPermission == LocationPermission.deniedForever) {
    print('Você precisa autorizar o acesso à localização (Manualmente)');
    return null;
  }

  try {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  } catch (e) {
    print('Erro ao obter localização: $e');
    return null;
  }
}
