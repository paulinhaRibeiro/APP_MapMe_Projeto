import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:mapeme/Screens/CRUD_Screens/atualiza_point.dart';
import 'package:mapeme/Screens/CRUD_Screens/tab_listagens.dart';

// para imagem de slide
import 'package:mapeme/Screens/Widgets/image_slider_details.dart';
import 'package:mapeme/Screens/Widgets/connection_web.dart';

import '../Route/drop_down_choice_route.dart';
import '../Widgets/utils/informativo.dart';
import '../Widgets/listagem_widgets.dart/descricao_point_widget.dart';

class DetailsPoint extends StatefulWidget {
  // recebe a função de callback
  final VoidCallback onUpdateLista;

  // Para quando abrir a tela já ter o obj carregado
  final PointInterest p;
  const DetailsPoint({super.key, required this.p, required this.onUpdateLista});

  @override
  State<DetailsPoint> createState() => _DetailsPointState();
}

class _DetailsPointState extends State<DetailsPoint> {
  // instancia do bd
  var db = GetIt.I.get<ManipuTablePointInterest>();
  // para atualizar os dados na tela de detalhes
  late PointInterest _updatedPoint;
  // Lista das imgs do ponto de interesse
  List<String> imagesPathList = [];
  // Para o campo do tipo do ponto
  bool _showType = false;

  // Função para add as imgs a lista
  _addImagensList() {
    if (_updatedPoint.img1 != "") {
      imagesPathList.add(_updatedPoint.img1);
    }
    if (_updatedPoint.img2 != "") {
      imagesPathList.add(_updatedPoint.img2);
    }
  }

  @override
  void initState() {
    super.initState();
    _updatedPoint = widget.p;
    // para add as img na lista
    _addImagensList();
  }

  // _aviso(String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Center(
  //         child: Text(
  //           msg,
  //           style: const TextStyle(
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _voltarScreen() {
    Navigator.of(context).pop();
  }

  _voltarScreen2() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const ListagemDados(),
      ),
      (route) => false,
    );
  }

  _confirmDeleteDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirmar Exclusão",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Tem certeza de que deseja excluir este ponto de interesse?",
          ),
          actions: <Widget>[
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _apagarPoi();
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

  // Deletar o Ponto de interesse
  _apagarPoi() async {
    // Se for um ponto de interesse ligado a uma rota
    if (widget.p.foreignidRoute != null) {
      // chama a função do bd q verifica a quantidade pontps de interesse
      //ligados a rota e excluir a rota se o utimo ponto de interesse for excluido
      await db.countRecordsWithName(widget.p.foreignidRoute!, widget.p.id);
      // Navega para a tela de listagem
      _voltarScreen2();
    } else {
      // se a exclusão for de um ponto de interesse q não é ligado a uma rota
      // exclui normalmente
      await db.deletePointInterest(widget.p.id);
      // Atualiza a listagem dos dados -> AtualizaDados
      widget.onUpdateLista();
      _voltarScreen();
      // ignore: use_build_context_synchronously
      Aviso.showSnackBar(context, "Item Excluído");
      // _aviso("Item Excluído");
    }
    // Original
    // await db.deletePointInterest(widget.p.id);
    // widget.onUpdateLista();
    // _voltarScreen();
    // _aviso("Item Excluído");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Detalhes do Ponto de Interesse'),
        actions: [
          // Se tiver um tipo defindo, aparece o icon de estrela
          if (_updatedPoint.typePointInterest != "TIPO NÃO IDENTIFICADO")
            IconButton(
              tooltip: "Tipo do Ponto de Interesse",
              icon: const Icon(
                Icons.star,
                color: Color(0xFF2C5100),
              ),
              onPressed: () {
                setState(() {
                  _showType = !_showType;
                });
              },
            ),

          // Opções de editar e remover
          PopupMenuButton(
            tooltip: "Mais Opções",
            itemBuilder: (BuildContext context) {
              return [
                // opc Add a uma Rota
                // Se for um ponto de interesse q não é ligado a nenhuma rota
                if (_updatedPoint.foreignidRoute == null)
                  const PopupMenuItem(
                    value: 'AddRota',
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_rounded),
                        SizedBox(width: 10),
                        Text(
                          'Adicionar a uma Rota',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 63, 6),
                          ),
                        ),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'Editar',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded),
                      SizedBox(width: 10),
                      Text(
                        'Editar Ponto',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 63, 6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Remover
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
                        'Remover Ponto',
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
            // Editar ponto de interesse
            onSelected: (value) {
              if (value == 'Editar') {
                // chama a tela de editar o ponto de interesse
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AtualizarCadastroPoi(
                      // Passa os valores deste ponto de interesse
                      p: _updatedPoint,
                      // Atualiza o _updatedPoint de acordo com os valores alterados na tela de edição
                      onUpdate: (updatedPoint) {
                        setState(() {
                          _updatedPoint = updatedPoint;
                          // Exclui tds os itens da lista
                          imagesPathList.clear();
                          // Chama a função para inserir novamente de acordo com os dados alterados
                          _addImagensList();
                        });
                        // E atualiza a listagem - Callback
                        widget.onUpdateLista();
                      },
                    ),
                  ),
                );
              } else if (value == 'Remover') {
                _confirmDeleteDialog();
              } else if (value == 'AddRota') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DropPageChoiceRoute(
                              addRoutePoint: _updatedPoint,
                            )));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagemDetailsScreen(
              // lista das imagens
              imagesList: imagesPathList,
              name: _updatedPoint.name,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Descrição',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      // Só vai aparecer a estrela se o tipo não for TIPO NÃO IDENTIFICADO
                      if (_showType)
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _updatedPoint.typePointInterest,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 63, 6),
                              ),
                            ),
                          ),
                        )),
                    ],
                  ),

                  const SizedBox(height: 8),

                  DescriptonPoint(
                    description: _updatedPoint.description,
                    numLines: 50,
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Localização',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  DescriptonPoint(
                    description:
                        'O ponto "${_updatedPoint.name}" está situado a uma latitude de "${_updatedPoint.latitude}" e uma longitude de "${_updatedPoint.longitude}".',
                    numLines: 50,
                  ),

                  // Botão de ver no mapa
                  const SizedBox(height: 24),
                  WebPageSite(
                    lat: _updatedPoint.latitude.toString(),
                    long: _updatedPoint.longitude.toString(),
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
