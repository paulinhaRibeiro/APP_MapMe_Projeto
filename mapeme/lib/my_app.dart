import 'package:flutter/material.dart';
import 'package:mapeme/pages/authtentication/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MapMe",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define a cor primária personalizada do APP
        // tema gerado apartir do Material 3
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00610A), 
          // brightness: Brightness.light,
          primary:  const Color(0xFF00610A),
        ),
      ),
      home: const PageLogin(),
    );
  }
}
