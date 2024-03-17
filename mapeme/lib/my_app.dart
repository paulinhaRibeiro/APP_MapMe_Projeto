import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapeme/Screens/authtentication/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Para usar somente modo retrato
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    return MaterialApp(
      title: "MapMe",
      debugShowCheckedModeBanner: false,
      // tema
      theme: ThemeData(
        // Define a cor primária personalizada do APP
        // tema gerado apartir do Material 3
        useMaterial3: true,

        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Layout do AppBar
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: Colors.white,
          elevation: 4.0,
          shadowColor: Theme.of(context).colorScheme.shadow,
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 0, 63, 6),
              fontWeight: FontWeight.w900,
              fontSize: 20),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 0, 63, 6),
          ),
        ),

        // Layout do TabBar
        tabBarTheme: TabBarTheme.of(context).copyWith(
          unselectedLabelColor: Colors.grey[500],
          labelStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),

        // Color.fromARGB(255, 174, 229, 179),),
        // Color(0xFF00610A),

        // Cores do aplicativo
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 63, 6),
          primary: const Color.fromARGB(255, 0, 63, 6),
        ).copyWith(
          surfaceTint: Colors.transparent,
          background: Colors.grey[50]!,
        ),
      ),
      home: const PageLogin(),
    );
  }
}
