import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_route.dart';
import 'package:mapeme/Models/route.dart';
import 'package:mapeme/Screens/Route/ordena_iniciar_Rota/iniciar_rota.dart';

import '../../BD/table_point_interest.dart';
import '../Widgets/image_slider_details.dart';
import '../Widgets/utils/informativo.dart';
import '../Widgets/listagem_widgets.dart/descricao_point_widget.dart';
// import '../Widgets/listagem_widgets.dart/nome_point_widget.dart';
// import '../Widgets/text_button.dart';
import 'edit_route.dart';
import 'lista_point_routes.dart';

class DetailsRoute extends StatefulWidget {
  // Callback -> atualizaDados
  final VoidCallback onUpdateLista;
  // Para quando abrir a tela já ter o obj carregado
  final RoutesPoint route;
  const DetailsRoute(
      {super.key, required this.route, required this.onUpdateLista});

  @override
  State<DetailsRoute> createState() => _DetailsRouteState();
}

class _DetailsRouteState extends State<DetailsRoute> {
  // referencias as tabelas
  var dbRoute = GetIt.I.get<ManipuTableRoute>();
  var bdPoint = GetIt.I.get<ManipuTablePointInterest>();

  // para atualizar os dados na tela de detalhes
  late RoutesPoint _updatedRoute;
  // Para receber todas as imgs dos pontos de interesse da rota
  List<String> imagesPathList = [];

  // Para Capturar todas as imagens dos pontos de interesse da rota
  Future<void> _addImagensList() async {
    // Apaga todos os elementos da lista de imgs
    imagesPathList.clear();
    // Captura as img1
    List<String> imagens1 =
        await bdPoint.getPointInterestImages1(_updatedRoute.idRoute);
    // Captura as img2
    List<String> imagens2 =
        await bdPoint.getPointInterestImages2(_updatedRoute.idRoute);

    // Atualiza a lista com essas imgs
    setState(() {
      imagesPathList.addAll(imagens1);
      imagesPathList.addAll(imagens2);
    });
  }

  @override
  void initState() {
    super.initState();
    // Atualiza a _updatedRoute com os valores recebidos anteriormente
    _updatedRoute = widget.route;
    // conecta ao bd e pega todas as imagens dos pontos de interesse
    _addImagensList();
  }

  // Voltar a outra tela
  _voltarScreen() {
    Navigator.of(context).pop();
  }

  // Confirma se quer realmente excluir a rota
  _confirmDeleteDialog() async {
    return showDialog(
      context: context,
      // impede o fechamento ao tocar fora do diálogo
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirmar Exclusão",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Tem certeza de que deseja excluir esta Rota?",
          ),
          actions: <Widget>[
            // Se clicar em Cancelar, só fecha o AlertDialog
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 91, 91, 91),
                ),
              ),
            ),

            // Se clicar em Excluir
            ElevatedButton(
              onPressed: () {
                // fecha o AlertDialog
                Navigator.of(context).pop(true);
                // E chama a Função de apagar a Rota
                _apagarRoute();
              },
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor:
                    const Color.fromARGB(202, 244, 67, 54), // Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Excluir",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        );
      },
    );
  }

  _apagarRoute() async {
    // Chama a operação de deletar a rota no bd
    await dbRoute.deleteRoute(widget.route.idRoute);
    // executa a função de callback AtualizaDados da tela de listagem
    widget.onUpdateLista();
    // E volta para a tela de listagem
    _voltarScreen();
    // Lança o aviso
    // ignore: use_build_context_synchronously
    Aviso.showSnackBar(context, "Item Excluído");
    // _aviso("Item Excluído");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Detalhes da Rota'),
        actions: [
          PopupMenuButton(
            tooltip: "Mais Opções",
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Editar',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded),
                      SizedBox(width: 10),
                      Text(
                        'Editar Rota',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 63, 6),
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'Remover',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_rounded,
                        color: Color(0xFF9F0000),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Remover Rota',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9F0000),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            // clicar em editar
            onSelected: (value) {
              if (value == 'Editar') {
                // Vai para a tela de edição da rota
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditRoute(
                      // Passa os dados da Rota
                      route: _updatedRoute,
                      // Executa a função para atualizar os itens da tela de detalhes da rota
                      onUpdate: (updatedRoute) {
                        setState(() {
                          _updatedRoute = updatedRoute;
                        });
                        // Executa a função de Callback para atualizar a listagem das rotas
                        widget.onUpdateLista();
                      },
                    ),
                  ),
                );
              } else if (value == 'Remover') {
                _confirmDeleteDialog();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImagemDetailsScreen(
              imagesList: imagesPathList,
              name: _updatedRoute.nameRoute,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  DescriptonPoint(
                    description:
                        "Rota: ${_updatedRoute.nameRoute}. ${_updatedRoute.descriptionRoute}",
                    numLines: 50,
                  ),

                  const SizedBox(height: 24),
//

                  // Botão de iniciar a Rota
                  SizedBox(
                    width: double.infinity,
                    child: IniciarRota(idRoute: _updatedRoute.idRoute),),
                    
                  //   ElevatedButton.icon(
                  //     onPressed: () {
                  //       // Chama a Tela de listagem dos pontos de interesse da rota
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => IniciarRota(
                  //             idRoute: _updatedRoute.idRoute,
                              
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                  //       elevation: 10,
                  //       minimumSize: const Size.fromHeight(55),
                  //     ),
                  //     icon: const Icon(
                  //       Icons.play_arrow,
                  //       color: Colors.white,
                  //     ),
                  //     label: const ScreenTextButtonStyle(text: "Iniciar Rota"),
                  //   ),
                  // ),
                  const SizedBox(height: 16),

                  //
                  // Botão para ir para os Pontos de interesse da rota
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Chama a Tela de listagem dos pontos de interesse da rota
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListagemPointsRoute(
                              // Passa o id da Rota
                              idRoute: _updatedRoute.idRoute,
                              // Nome da Rota
                              nameRoute: _updatedRoute.nameRoute,
                              // Função de callback para atualizar as imgs quando um ponto for alterado
                              onUpdateListaRoutePoints: _addImagensList,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 10,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(
                        Icons.place,
                        color: Color.fromARGB(255, 0, 63, 6),
                      ),
                      label: const Text(
                        'Pontos de Interesse da Rota',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 63, 6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
