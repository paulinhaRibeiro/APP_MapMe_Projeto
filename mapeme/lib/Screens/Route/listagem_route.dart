import 'package:flutter/material.dart';
import 'package:mapeme/Screens/Route/details_route.dart';
// import 'package:get_it/get_it.dart';
import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/circulo_progresso_widget.dart';
import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/nome_point_widget.dart';

import '../../Models/route.dart';

class ListagemRoute extends StatelessWidget {
  final VoidCallback onUpdateListaRoute;
  final Future<List<RoutesPoint>> itemsRoute;
  const ListagemRoute(
      {super.key, required this.itemsRoute, required this.onUpdateListaRoute});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RoutesPoint>>(
      // cria o obj em cima da variavel items
      future: itemsRoute,
      // para desenhar na tela
      builder: (context, snapshot) {
        // se o print que tirar (snapshot) tiver algum dado - desenha a lista
        if (snapshot.hasData) {
          List<RoutesPoint> data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              // Card dos elementos do bd
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: InkWell(
                  // Usando InkWell para adicionar interatividade ao Card

                  onTap: () {
                    // Ação ao tocar no Card
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsRoute(
                          onUpdateLista: onUpdateListaRoute,
                          route: data[index],
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // campo da imagem
                      // data[index].imgRoute != ""
                      //     ? ImagemPoint(
                      //         nomeImagem: data[index].imgRoute)
                      //     : ImagemPoint(
                      //         nomeImagem: data[index].imgRoute),

                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.asset(
                          'assets/images_geral/map_img.png',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        // child: Container(
                        //   height: 150,
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey[200],
                        //   ),
                        //   child: const Center(
                        //     child: Text(
                        //       "Não há imagem disponível!",
                        //       textAlign: TextAlign.center,
                        //       style: TextStyle(
                        //         color: Colors.grey,
                        //         // color: Colors.white,
                        //         fontSize: 16,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NomePoint(
                              nomePoint: "Rota: ${data[index].nameRoute}",
                            ),
                            const SizedBox(height: 8),
                            // descrição
                            DescriptonPoint(
                                description: data[index].descriptionRoute),
                            const SizedBox(height: 12),
                            // Texto de ponto turístico
                            // NameTypePointInteresse(
                            //   nameTypePoint:
                            //       data[index].typePointInterest,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            padding: const EdgeInsets.all(10),
          );
        } else if (snapshot.hasError) {
          // se o snapshot possuir um erro
          Text("${snapshot.error}"); //exibi na tela o erro
        }

        //caso contrario retorna o circulo de progresso
        return const Circulo();
      },
    );
  }
}
