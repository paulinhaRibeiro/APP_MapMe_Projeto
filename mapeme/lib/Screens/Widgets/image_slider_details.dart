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
  List imgList = [];
  // List<Map<String, dynamic>> imgList = [];

  @override
  // método disparado quando criar essa tela
  void initState() {
    super.initState();
    if (widget.img1.isNotEmpty) {
      imgList.add({"id": 1, "img_path": File(widget.img1)});
    }

    if (widget.img2.isNotEmpty) {
      imgList.add({"id": 2, "img_path": File(widget.img2)});
    }
    // debugPrint("${imgList.length}");
  }
  // List imgList = [
  //   {"id": 1, "img_path": "assets/images_logo/logo1.png"},
  //   {"id": 2, "img_path": "assets/images_geral/gritador_teste.png"},
  //   // {"id": 3, "img_path": "assets/images_logo/logo1.png"},
  // ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            imgList.isNotEmpty
                ? InkWell(
                    onTap: () {
                      // print(currentIndex);
                    },
                    child: CarouselSlider(
                      items: imgList
                          .map(
                            (item) => Image.file(
                              item['img_path'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                          .toList(),
                      carouselController: carouselController,
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
                    color: Colors.grey[200],// Cor de fundo do container
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
                children: imgList.asMap().entries.map((entry) {
                  // print(entry);
                  // print(entry.key);
                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      width: currentIndex == entry.key ? 17 : 7,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: currentIndex == entry.key
                              ? const Color.fromARGB(255, 92, 205, 0) //Colors.grey[200] // const Color.fromARGB(255, 0, 150, 62) // Colors.teal
                              : Colors.red),//Colors.grey[400]),//Colors.red),
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
