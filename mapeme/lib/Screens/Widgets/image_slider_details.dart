import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImagemDetailsScreen extends StatefulWidget {
  final List<String> imagesList;
  const ImagemDetailsScreen(
      {super.key,
      required this.imagesList});

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
            (widget.imagesList.isNotEmpty)
                ? InkWell(
                    onTap: () {
                      debugPrint("$currentIndex");
                    },
                    child: CarouselSlider(
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
                        scrollPhysics: const BouncingScrollPhysics(),
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
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
                children: widget.imagesList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
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

// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class ImagemDetailsScreen extends StatefulWidget {
//   final String img1;
//   final String img2;
//   final List<String> imagesList;
//   const ImagemDetailsScreen(
//       {super.key, required this.img1, required this.img2, required this.imagesList});

//   @override
//   State<ImagemDetailsScreen> createState() => _ImagemDetailsScreenState();
// }

// class _ImagemDetailsScreenState extends State<ImagemDetailsScreen> {
//   final CarouselController carouselController = CarouselController();
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             (widget.img1.isNotEmpty || widget.img2.isNotEmpty)
//                 ? InkWell(
//                     onTap: () {
//                       // print(currentIndex);
//                     },
//                     child: CarouselSlider(
//                       items: [
//                         if (widget.img1.isNotEmpty)
//                           Image.file(
//                             File(widget.img1),
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                         if (widget.img2.isNotEmpty)
//                           Image.file(
//                             File(widget.img2),
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                       ],

//                       // carouselController: carouselController,
//                       options: CarouselOptions(
//                         scrollPhysics: const BouncingScrollPhysics(),
//                         autoPlay: true,
//                         aspectRatio: 2,
//                         viewportFraction: 1,
//                         onPageChanged: (index, reason) {
//                           setState(() {
//                             currentIndex = index;
//                           });
//                         },
//                       ),
//                     ),
//                   )
//                 : Container(
//                     color: Colors.grey[200], // Cor de fundo do container
//                     height: MediaQuery.of(context).size.width *
//                         .5, // Mesma altura da imagem
//                     child: const Center(
//                       child: Text(
//                         'Não há imagem disponível!',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           // color: Colors.white,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//             Positioned(
//               bottom: 10,
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (widget.img1.isNotEmpty)
//                     GestureDetector(
//                       onTap: () {
//                         carouselController.animateToPage(0);
//                       },
//                       child: Container(
//                         width: currentIndex == 0 ? 17 : 7,
//                         height: 7.0,
//                         margin: const EdgeInsets.symmetric(horizontal: 3.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: currentIndex == 0
//                               ? Colors
//                                   .white //const Color.fromARGB(255, 92, 205, 0)
//                               : Colors.grey,
//                         ),
//                       ),
//                     ),
//                   if (widget.img2.isNotEmpty)
//                     GestureDetector(
//                       onTap: () {
//                         carouselController
//                             .animateToPage(widget.img1.isNotEmpty ? 1 : 0);
//                       },
//                       child: Container(
//                         width: currentIndex == (widget.img1.isNotEmpty ? 1 : 0)
//                             ? 17
//                             : 7,
//                         height: 7.0,
//                         margin: const EdgeInsets.symmetric(horizontal: 3.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: currentIndex ==
//                                   (widget.img1.isNotEmpty ? 1 : 0)
//                               ? Colors
//                                   .white //const Color.fromARGB(255, 92, 205, 0)
//                               : Colors.grey,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }

// AAAAAAAAAAAAAAAAAAAAA

// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class ImagemDetailsScreenX extends StatefulWidget {
//   final String img1;
//   final String img2;
//   const ImagemDetailsScreenX(
//       {super.key, required this.img1, required this.img2});

//   @override
//   State<ImagemDetailsScreen> createState() => _ImagemDetailsScreenState();
// }

// class _ImagemDetailsScreenXState extends State<ImagemDetailsScreenX> {
//   // List imgList = [
//   //   {"id": 1, "img_path": "assets/images_logo/logo1.png"},
//   //   {"id": 2, "img_path": "assets/images_geral/gritador_teste.png"},
//   //   // {"id": 3, "img_path": "assets/images_logo/logo1.png"},
//   // ];
//   List imgList = [];

//   final CarouselController carouselController = CarouselController();
//   int currentIndex = 0;
//   // List<Map<String, dynamic>> imgList = [];

//   @override
//   // método disparado quando criar essa tela
//   void initState() {
//     super.initState();
//     if (widget.img1.isNotEmpty) {
//       imgList.add({"id": 1, "img_path": File(widget.img1)});
//     }

//     if (widget.img2.isNotEmpty) {
//       imgList.add({"id": 2, "img_path": File(widget.img2)});
//     }
//     // debugPrint("${imgList.length}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             imgList.isNotEmpty
//                 ? InkWell(
//                     onTap: () {
//                       // print(currentIndex);
//                     },
//                     child: CarouselSlider(
//                       items: imgList
//                           .map(
//                             (item) => Image.file(
//                               item['img_path'],
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                             ),
//                           )
//                           .toList(),
//                       carouselController: carouselController,
//                       options: CarouselOptions(
//                         scrollPhysics: const BouncingScrollPhysics(),
//                         autoPlay: true,
//                         aspectRatio: 2,
//                         viewportFraction: 1,
//                         onPageChanged: (index, reason) {
//                           setState(() {
//                             currentIndex = index;
//                           });
//                         },
//                       ),
//                     ),
//                   )
//                 : Container(
//                     color: Colors.grey[200], // Cor de fundo do container
//                     height: MediaQuery.of(context).size.width *
//                         .5, // Mesma altura da imagem
//                     child: const Center(
//                       child: Text(
//                         'Não há imagem disponível!',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           // color: Colors.white,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//             Positioned(
//               bottom: 10,
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: imgList.asMap().entries.map((entry) {
//                   // print(entry);
//                   // print(entry.key);
//                   return GestureDetector(
//                     onTap: () => carouselController.animateToPage(entry.key),
//                     child: Container(
//                       width: currentIndex == entry.key ? 17 : 7,
//                       height: 7.0,
//                       margin: const EdgeInsets.symmetric(horizontal: 3.0),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: currentIndex == entry.key
//                               ? const Color.fromARGB(255, 92, 205,
//                                   0) //Colors.grey[200] // const Color.fromARGB(255, 0, 150, 62) // Colors.teal
//                               : Colors.red), //Colors.grey[400]),//Colors.red),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }
