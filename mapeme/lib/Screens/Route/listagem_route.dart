import 'package:flutter/material.dart';
import 'package:mapeme/Screens/Route/details_route.dart';
import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/circulo_progresso_widget.dart';
import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/nome_point_widget.dart';

import '../../Models/route.dart';

// Lista todas as Rotas atraves de cards
class ListagemRoute extends StatelessWidget {
  // Função de Callback
  final VoidCallback onUpdateListaRoute;
  // Todas as Rotas cadastradas
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
                    // Chama a tela de detalhes
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsRoute(
                          // Passando a função de callback "atualizaDados"
                          onUpdateLista: onUpdateListaRoute,
                          // Recebe todos os dados da rota que foi clicada
                          route: data[index],
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Image.asset(
                          'assets/images_geral/map_img.png',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: NomePoint(
                                nomePoint: data[index].nameRoute,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // descrição
                            DescriptonPoint(
                                description: data[index].descriptionRoute),
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
