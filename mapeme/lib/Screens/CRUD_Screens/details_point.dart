import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:mapeme/Screens/CRUD_Screens/atualiza_point.dart';
import 'package:mapeme/Screens/CRUD_Screens/tab_listagens.dart';

// para imagem de slide
import 'package:mapeme/Screens/Widgets/image_slider_details.dart';
// import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/turistico_widget.dart';
import 'package:mapeme/Screens/Widgets/connection_web.dart';

// import '../Widgets/divide_text.dart';
import '../Widgets/listagem_widgets.dart/descricao_point_widget.dart';
// import '../Widgets/listagem_widgets.dart/nome_point_widget.dart';
// import '../Widgets/text_button.dart';

class DetailsPoint extends StatefulWidget {
  final VoidCallback onUpdateLista;

  // Para quando abrir a tela já ter o obj carregado
  final PointInterest p;
  const DetailsPoint({super.key, required this.p, required this.onUpdateLista});

  @override
  State<DetailsPoint> createState() => _DetailsPointState();
}

class _DetailsPointState extends State<DetailsPoint> {
  var db = GetIt.I.get<ManipuTablePointInterest>();

  late PointInterest _updatedPoint;

  List<String> imagesPathList = [];

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
    // para add as img nas lista
    _addImagensList();
  }

  _aviso(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            msg,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _voltarScreen() {
    Navigator.of(context).pop();
  }

  _voltarScreen2() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ListagemDados()));
  }

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

  _apagarPoi() async {
    // bool confirmDelete = await _confirmDeleteDialog();
    // if (confirmDelete) {
    if (widget.p.foreignidRoute != null) {
      await db.countRecordsWithName(widget.p.foreignidRoute!, widget.p.id);
      _voltarScreen2();
    } else {
      await db.deletePointInterest(widget.p.id);
      widget.onUpdateLista();
      _voltarScreen();
      _aviso("Item Excluído");
    }
    // Original
    // await db.deletePointInterest(widget.p.id);
    // widget.onUpdateLista();
    // _voltarScreen();
    // _aviso("Item Excluído");
    // }
  }

  bool _showType = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Detalhes do Ponto de Interesse'),
        actions: [
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
                        'Editar Ponto',
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
            onSelected: (value) {
              if (value == 'Editar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AtualizarCadastroPoi(
                      p: _updatedPoint,
                      onUpdate: (updatedPoint) {
                        setState(() {
                          _updatedPoint = updatedPoint;
                          imagesPathList.clear();

                          _addImagensList();
                        });

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
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         'Descrição do Ponto',
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.grey[800],
                  //         ),
                  //       ),
                  //     ),
                  //     // Expanded(
                  //     //   child: NameTypePointInteresse(
                  //     //     nameTypePoint: _updatedPoint.typePointInterest,
                  //     //   ),
                  //     // ),

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
