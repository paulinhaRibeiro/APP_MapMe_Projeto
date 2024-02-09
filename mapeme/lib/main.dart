import 'package:flutter/material.dart';
import 'package:mapeme/pages/authtentication/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define a cor primária personalizada do APP
        // tema gerado apartir do Material 3
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00610A), 
          // brightness: Brightness.light,
          primary:  const Color(0xFF00610A),
        ),

        //tema escuro
        // brightness: Brightness.dark,

        // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00910E)),
        // iconButtonTheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00910E)),
      ),
      debugShowCheckedModeBanner: false,
      home: const PageLogin(),
    );
  }
}
