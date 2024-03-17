import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:mapeme/Screens/CRUD_Screens/atualiza_point.dart';

// para imagem de slide
import 'package:mapeme/Screens/Widgets/image_slider_details.dart';
import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/turistico_widget.dart';

import '../Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import '../Widgets/listagem_widgets.dart/nome_point_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _updatedPoint = widget.p;
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

  _apagarPoi() async {
    // bool confirmDelete = await _confirmDeleteDialog();
    // if (confirmDelete) {
    await db.deletePointInterest(widget.p.id);
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
        title: const Text("Detalhes do Point"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagemDetailsScreen(
              img1: _updatedPoint.img1,
              img2: _updatedPoint.img2,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      NomePoint(
                        nomePoint: _updatedPoint.name,
                        numLines: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TuristicPoint(
                          pontoTuristico: _updatedPoint.turisticPoint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DescriptonPoint(
                    description: _updatedPoint.description,
                    numLines: 50,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AtualizarCadastroPoi(
                      p: _updatedPoint,
                      onUpdate: (updatedPoint) {
                        setState(() {
                          _updatedPoint = updatedPoint;
                        });

                        widget.onUpdateLista();
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar'),
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
              label: const Text('Deletar'),
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
