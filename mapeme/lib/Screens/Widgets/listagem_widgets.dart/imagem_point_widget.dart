import 'dart:io';

import 'package:flutter/material.dart';

class ImagemPoint extends StatelessWidget {
  final String nomeImagem;

  const ImagemPoint({super.key, required this.nomeImagem});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: nomeImagem != ""
          ? Image.file(
              File(nomeImagem),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: const Center(
                child: Text(
                  "Não há imagem disponível!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    // color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
    );
  }
}
