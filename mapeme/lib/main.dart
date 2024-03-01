import 'package:flutter/material.dart';
import 'package:mapeme/my_app.dart';

// Para o bd
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/database_helper.dart';
import 'package:mapeme/BD/table_point_interest.dart';
// import 'package:mapeme/Screens/listagem_point.dart';

// instancia do getIt - gerenciador de dependencia
final getIt = GetIt.instance;

void setConfiguration() {
  // carregamento tardio e uma unica instancia em memória
  // Registra a BD no GetIt
  getIt.registerLazySingleton(() => DataBaseHelper());
  // Registra a tabela no GetIt
  getIt.registerLazySingleton(() => ManipuTablePointInterest());
}

void main() async {
  // é assincrona pq tera operações operações realizadas de forma assincrona

  // para executar somente quando os componentes minimos do flutter serem carregados
  WidgetsFlutterBinding.ensureInitialized();
  setConfiguration();

  runApp(const MyApp());
}
