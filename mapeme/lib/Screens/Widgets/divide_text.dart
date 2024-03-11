import 'package:flutter/material.dart';

class DividerText extends StatelessWidget {
  const DividerText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Divider(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Cadastrar Imagem',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
