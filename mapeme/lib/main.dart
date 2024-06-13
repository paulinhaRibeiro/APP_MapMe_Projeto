import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mapeme/my_app.dart';

// Para o bd
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/database_helper.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/services/auth_service.dart';
// import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'BD/table_route.dart';

// instancia do getIt - gerenciador de dependencia
final getIt = GetIt.instance;

void setConfiguration() {
  // carregamento tardio e uma unica instancia em memória
  // Registra a BD no GetIt
  getIt.registerLazySingleton(() => DataBaseHelper());
  // Registra a tabela do PointInteresse no GetIt
  getIt.registerLazySingleton(() => ManipuTablePointInterest());
  // Registra a tabela Route  no GetIt
  getIt.registerLazySingleton(() => ManipuTableRoute());
}

void main() async {
  // é assincrona pq tera operações operações realizadas de forma assincrona

  // para executar somente quando os componentes minimos do flutter serem carregados
  WidgetsFlutterBinding.ensureInitialized();

  //carregamento da variavel de ambiente
  await FlutterConfig.loadEnvVariables();
  setConfiguration();

  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}
