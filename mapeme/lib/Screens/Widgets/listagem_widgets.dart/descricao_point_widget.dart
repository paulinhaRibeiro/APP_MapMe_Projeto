import 'package:flutter/material.dart';

class DescriptonPoint extends StatelessWidget {
  final String description;
  const DescriptonPoint({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Define a largura da descrição
      flex: 3,
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
