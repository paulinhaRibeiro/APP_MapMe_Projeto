import 'package:geolocator/geolocator.dart';

// Para armazenar mensagens de erro
String? errorLocation;

// Método para obter a localização atual
Future<Position?> obterLocalizacaoAtual() async {
  
  LocationPermission locationPermission;
  bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!locationServiceEnabled) {
    // Se o serviço de localização estiver desativado, define a mensagem de erro
    errorLocation = 'Por favor, habilite a localização no smartphone';
  }

  locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    // Se a permissão de localização for negada, solicita permissão ao usuário
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      // Se o usuário negar a permissão, define a mensagem de erro
      errorLocation = 'Você precisa autorizar o acesso à localização';
      
    }
  }

  if (locationPermission == LocationPermission.deniedForever) {
    // Se o usuário negar a permissão permanentemente, define a mensagem de erro
    errorLocation = 'Você precisa autorizar o acesso à localização (Manualmente)';
  }

  try {
    // Obtém a posição atual do dispositivo com alta precisão
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // para saber a distancia em metros de um ponto a outro.
    // double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    // print("em metro $distanceInMeters");
    return position;
  } catch (e) {
    // Se ocorrer um erro ao obter a posição, define a mensagem de erro
    errorLocation = 'Erro ao obter localização: $e - $errorLocation';
    return null;
  }
}
