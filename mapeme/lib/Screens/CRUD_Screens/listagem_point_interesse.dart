import 'package:flutter/material.dart';

import '../../Models/point_interest.dart';
import '../Widgets/listagem_widgets.dart/circulo_progresso_widget.dart';
import '../Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import '../Widgets/listagem_widgets.dart/imagem_point_widget.dart';
import '../Widgets/listagem_widgets.dart/nome_point_widget.dart';
import '../Widgets/listagem_widgets.dart/turistico_widget.dart';
import 'details_point.dart';

class ListagemPointInteresse extends StatelessWidget {
  final VoidCallback onUpdateListaPoint;
  final Future<List<PointInterest>> itemsPoint;
  const ListagemPointInteresse(
      {super.key, required this.onUpdateListaPoint, required this.itemsPoint});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PointInterest>>(
      // cria o obj em cima da variavel items
      future: itemsPoint,
      // para desenhar na tela
      builder: (context, snapshot) {
        // se o print que tirar (snapshot) tiver algum dado - desenha a lista
        if (snapshot.hasData) {
          List<PointInterest> data = snapshot.data!;

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
                        builder: (context) => DetailsPoint(
                          onUpdateLista: onUpdateListaPoint,
                          p: data[index],
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // campo da imagem
                      data[index].img1 != ""
                          ? ImagemPoint(nomeImagem: data[index].img1)
                          : ImagemPoint(nomeImagem: data[index].img2),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: NomePoint(
                                nomePoint: data[index].name,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // descrição
                            DescriptonPoint(
                                description: data[index].description),
                            // const SizedBox(height: 8),
                            // // Texto de ponto turístico
                            // NameTypePointInteresse(
                            //   nameTypePoint: data[index].typePointInterest,
                            // ),
                            if (data[index].typePointInterest !=
                                "TIPO NÃO IDENTIFICADO") ...[
                              const SizedBox(height: 8),
                              // Texto de punto turístico
                              NameTypePointInteresse(
                                nameTypePoint: data[index].typePointInterest,
                              ),
                            ],
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
