import 'package:flutter/material.dart';

import '../../Models/point_interest.dart';
import '../Widgets/listagem_widgets.dart/circulo_progresso_widget.dart';
import '../Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import '../Widgets/listagem_widgets.dart/imagem_point_widget.dart';
import '../Widgets/listagem_widgets.dart/nome_point_widget.dart';
import '../Widgets/listagem_widgets.dart/turistico_widget.dart';
import 'details_point.dart';

// Classe responsavel por listar todos os pontos de interesse
class ListagemPointInteresse extends StatelessWidget {
  // Função de callback para atualizar os dados -> AtualizarDados
  final VoidCallback onUpdateListaPoint;
  // Todos os pontos de interesse
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
                    // Chama a Tela de detalhes do ponto de interesse
                    // Não executa o callback aqui, é transferido para a outra tela
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPoint(
                          // passa a função de callback para ser executada posteriormente 
                          onUpdateLista: onUpdateListaPoint,
                          // recebe todos os dados do ponto de interesse quando clicado no card
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
          Text("${snapshot.error}"); //exibi o erro
        }

        //caso contrario retorna o circulo de progresso
        return const Circulo();
      },
    );
  }
}
