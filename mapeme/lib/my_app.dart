import 'package:flutter/material.dart';
import 'package:mapeme/Screens/authtentication/login_page.dart';

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
        // 
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 63, 6), 
            fontWeight: FontWeight.w900, 
            fontSize: 20
          ),
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 63, 6),),
        ),


        
        // appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 174, 229, 179),), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 63, 6),
          // brightness: Brightness.light,
          primary: const Color.fromARGB(255, 0, 63, 6), //Color(0xFF00610A),
        ),
      ),
      home: const PageLogin(),
    );
  }
}
