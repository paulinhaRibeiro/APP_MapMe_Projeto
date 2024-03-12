import 'package:flutter/material.dart';

class Circulo extends StatelessWidget {
  const Circulo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 80,
        width: 80,
        // Circulo de carregando
        child: CircularProgressIndicator(),
      ),
    );
  }
}
