import 'dart:io';

import 'package:flutter/material.dart';

class ImagemPoint extends StatelessWidget {
  final String nomeImagem;

  const ImagemPoint({super.key, required this.nomeImagem});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Define a largura da imagem
      flex: 2,
      child: Container(
        width: 100,
        height: 100,
        
        decoration: BoxDecoration(
          color:  Colors.grey[200],
          // Define as bordas arredondadas
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              // Cor da sombra
              color: Colors.grey.withOpacity(0.5),
              // Espalhamento da sombra
              spreadRadius: 2,
              // Raio de desfoque da sombra
              blurRadius: 5,
              // Deslocamento da sombra em x e y
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              // Adiciona bordas arredondadas à imagem
              BorderRadius.circular(8),
          child: nomeImagem != ""
              ? Image.file(
                  File(nomeImagem),
                  fit: BoxFit.cover,
                )
              : const Center(child: Text("Sem Imagem!", textAlign: TextAlign.center,)),//Icon(Icons.info),//Image.asset("assets/images_geral/gritador_teste.png"),
        ),
      ),
    );
  }
}
