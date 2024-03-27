import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_route.dart';
import 'package:mapeme/Models/route.dart';

// para imagem de slide

import '../../BD/table_point_interest.dart';
import '../Widgets/divide_text.dart';
import '../Widgets/image_slider_details.dart';
import '../Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import '../Widgets/listagem_widgets.dart/nome_point_widget.dart';

class DetailsRoute extends StatefulWidget {
  final VoidCallback onUpdateLista;

  // Para quando abrir a tela já ter o obj carregado
  final RoutesPoint route;
  const DetailsRoute(
      {super.key, required this.route, required this.onUpdateLista});

  @override
  State<DetailsRoute> createState() => _DetailsRouteState();
}

class _DetailsRouteState extends State<DetailsRoute> {
  var dbRoute = GetIt.I.get<ManipuTableRoute>();
  var bdPoint = GetIt.I.get<ManipuTablePointInterest>();

  late RoutesPoint _updatedRoute;
  List<String> imagesPathList = [];

  Future<void> _addImagensList() async {
    List<String> imagens1 =
        await bdPoint.getPointInterestImages1(_updatedRoute.idRoute);

    List<String> imagens2 =
        await bdPoint.getPointInterestImages2(_updatedRoute.idRoute);

    setState(() {
      imagesPathList.addAll(imagens1);
      imagesPathList.addAll(imagens2);
    });
    // debugPrint("img ${imagesPathList.length}");
  }

  @override
  void initState() {
    super.initState();
    _updatedRoute = widget.route;
    // conecta ao bd e pega todas as imagens dos pontos de interesse
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
                _apagarRoute();
              },
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: Colors.red,
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
    // bool confirmDelete = await _confirmDeleteDialog();
    // if (confirmDelete) {
    await dbRoute.deleteRoute(widget.route.idRoute);
    widget.onUpdateLista();
    _voltarScreen();
    _aviso("Item Excluído");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Detalhes da Rota"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagemDetailsScreen(
              // lista das imagens
              imagesList: imagesPathList,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NomePoint(
                    nomePoint: "Rota: ${_updatedRoute.nameRoute}",
                    numLines: 50,
                  ),
                  const SizedBox(height: 8),
                  DescriptonPoint(
                    description: _updatedRoute.descriptionRoute,
                    numLines: 50,
                  ),
                  const SizedBox(height: 12),

                  // Dividir a tela para a parte da Trajeto
                  const DividerText(
                    text: "Trajeto",
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .60,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(255, 195, 195, 195)),
                          image: const DecorationImage(
                            image: AssetImage('assets/images_geral/map_img.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            // backgroundColor: Colors.white.withOpacity(0.5),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.link),
                          label: const Text("Iniciar Trajeto"),
                        ),
                      ),
                    ),
                  ),

                  // Dividir a tela para a parte da Trajeto
                  const DividerText(
                    text: "Pontos de Interesses",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

//
//
      // Botôes de editar e apagar
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AtualizarCadastroPoi(
                //       p: _updatedPoint,
                //       onUpdate: (updatedPoint) {
                //         setState(() {
                //           _updatedPoint = updatedPoint;
                //         });

                //         widget.onUpdateLista();
                //       },
                //     ),
                //   ),
                // );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar Rota'),
              style: ElevatedButton.styleFrom(
                elevation: 10,
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton.icon(
              onPressed: () {
                _confirmDeleteDialog();
                // _apagarPoi();
              },
              icon: const Icon(Icons.delete),
              label: const Text('Deletar Rota'),
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
