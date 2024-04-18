import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImagemDetailsScreen extends StatefulWidget {
  // Lista de caminhos das imagens
  final List<String> imagesList;
  // nome do Ponto ou Rota
  final String name;
  const ImagemDetailsScreen(
      {super.key, required this.imagesList, required this.name});

  @override
  State<ImagemDetailsScreen> createState() => _ImagemDetailsScreenState();
}

class _ImagemDetailsScreenState extends State<ImagemDetailsScreen> {
  // Controlador para o carrossel
  final CarouselController carouselController = CarouselController();
  // Índice da imagem atualmente exibida
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // Verifica se há imagens na lista antes de exibir o carrossel
            (widget.imagesList.isNotEmpty)
                ? InkWell(
                    onTap: () {
                      // Imprime o índice da imagem atual ao ser clicada
                      debugPrint("$currentIndex");
                    },
                    child: Stack(
                      children: [
                        // Carrossel de imagens
                        CarouselSlider(
                          items: widget.imagesList
                              .map(
                                (item) => Image.file(
                                  File(item),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                              .toList(),
                          carouselController: carouselController,
                          options: CarouselOptions(
                            height: 250,
                            scrollPhysics: const BouncingScrollPhysics(),
                            // aspectRatio: 16 / 9, // Proporção da imagem
                            viewportFraction:
                                1, // Imagem ocupará toda a largura
                            initialPage: 0,
                            enableInfiniteScroll:
                                true, // Permitir rolagem infinita do carrossel
                            reverse: false,
                            autoPlay:
                                true, // Iniciar rotação automática das imagens
                            autoPlayInterval: const Duration(
                                seconds:
                                    3), // Intervalo entre as mudanças das imagens
                            autoPlayAnimationDuration: const Duration(
                                milliseconds:
                                    800), // Duração da animação entre as imagens
                            autoPlayCurve:
                                Curves.fastOutSlowIn, // Curva de animação
                            enlargeCenterPage: true,
                            scrollDirection: Axis
                                .horizontal, // Direção de rolagem do carrossel
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                        ),

                        // Posiciona o nome do Ponto ou da Rota na parte inferior do carrossel
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 50,
                            // Gradiente para fundo do texto
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      // Exibe um container com texto caso não haja imagens
                      Container(
                        color: Colors.grey[200], // Cor de fundo do container
                        // height: MediaQuery.of(context).size.width *
                        //     .5, // Mesma altura da imagem
                        height: 250,
                        child: const Center(
                          child: Text(
                            'Não há imagem disponível!',
                            style: TextStyle(
                              color: Colors.grey,
                              // color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),

                      // Posiciona o nome do Ponto ou da Rota na parte inferior do carrossel
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          // Gradiente para fundo do texto
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

            // Indicador de página (ponto) para cada imagem no carrossel
            Positioned(
              top: 20,
              // bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imagesList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      // Alterna a cor do indicador de acordo com a imagem atual
                      width: currentIndex == entry.key ? 17 : 7,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentIndex == entry.key
                            ? Colors.white
                            : Colors.grey,
                      ), //Colors.grey[400]),//Colors.red),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ],
    );
  }
}