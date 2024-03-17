import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImagemDetailsScreen extends StatefulWidget {
  final String img1;
  final String img2;
  const ImagemDetailsScreen(
      {super.key, required this.img1, required this.img2});

  @override
  State<ImagemDetailsScreen> createState() => _ImagemDetailsScreenState();
}

class _ImagemDetailsScreenState extends State<ImagemDetailsScreen> {
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            (widget.img1.isNotEmpty || widget.img2.isNotEmpty)
                ? InkWell(
                    onTap: () {
                      // print(currentIndex);
                    },
                    child: CarouselSlider(
                      items: [
                        if (widget.img1.isNotEmpty)
                          Image.file(
                            File(widget.img1),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        if (widget.img2.isNotEmpty)
                          Image.file(
                            File(widget.img2),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                      ],

                      // carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[200], // Cor de fundo do container
                    height: MediaQuery.of(context).size.width *
                        .5, // Mesma altura da imagem
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
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.img1.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        carouselController.animateToPage(0);
                      },
                      child: Container(
                        width: currentIndex == 0 ? 17 : 7,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: currentIndex == 0
                              ? Colors
                                  .white //const Color.fromARGB(255, 92, 205, 0)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  if (widget.img2.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        carouselController
                            .animateToPage(widget.img1.isNotEmpty ? 1 : 0);
                      },
                      child: Container(
                        width: currentIndex == (widget.img1.isNotEmpty ? 1 : 0)
                            ? 17
                            : 7,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: currentIndex ==
                                  (widget.img1.isNotEmpty ? 1 : 0)
                              ? Colors
                                  .white //const Color.fromARGB(255, 92, 205, 0)
                              : Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
