import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';

class AtualizarCadastroPoi extends StatefulWidget {
  const AtualizarCadastroPoi({super.key, required this.onUpdateList, required this.p});

  final VoidCallback onUpdateList;

  // Para quando abrir a tela já ter o obj carregado
  final PointInterest p; 

  @override
  State<AtualizarCadastroPoi> createState() => _AtualizarCadastroPoiState();
}

class _AtualizarCadastroPoiState extends State<AtualizarCadastroPoi> {

  final nomeController = TextEditingController();
  final descController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final img1Controller = TextEditingController();
  final img2Controller = TextEditingController();
  final pontoTuristicoController = TextEditingController();
  final sicronizadoController = TextEditingController();

  //

  var db = GetIt.I.get<ManipuTablePointInterest>();

  @override
  // Função que joga nas caixas de texto o que ja veio do Objeto
  // Isso é chamado sempre que criar a tela
  void initState(){
    super.initState();
    nomeController.text = widget.p.name;
    descController.text = widget.p.description;
    latitudeController.text = widget.p.latitude.toString();
    longitudeController.text = widget.p.longitude.toString();
    img1Controller.text = widget.p.img1;
    img2Controller.text = widget.p.img2;
    pontoTuristicoController.text = widget.p.turisticPoint.toString();
    sicronizadoController.text = widget.p.synced.toString();

  }

  _voltarScreen(){
    Navigator.of(context).pop();
  }

  _atualizarPoi() async {
    var p = PointInterest(
        id: widget.p.id, // recebe o id quando abriu a tela - Construtor
        name: nomeController.text,
        description: descController.text,
        latitude: double.parse(latitudeController.text),
        longitude: double.parse(longitudeController.text),
        img1: img1Controller.text,
        img2: img2Controller.text,
        turisticPoint: int.parse(pontoTuristicoController.text),
        synced: int.parse(sicronizadoController.text));
    await db.updatePointInterest(p);
    widget.onUpdateList();
    _voltarScreen();
  }


  _apagarPoi() async {
    await db.deletePointInterest(widget.p.id); // recebe o id quando abriu a tela - Construtor
    widget.onUpdateList();
    // Navigator.of(context).pop();
    _voltarScreen();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo POI"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("informe o nome"),
                    ),
                    controller: nomeController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("informe a Descrição"),
                    ),
                    controller: descController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextField(
                    // TextField que permite somente a visualização do dado
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("informe a Latitude"),
                    ),
                    controller: latitudeController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("informe a Longitude"),
                    ),
                    controller: longitudeController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("informe a img1"),
                    ),
                    controller: img1Controller,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("informe a img2"),
                    ),
                    controller: img2Controller,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("É ponto turistico?"),
                    ),
                    controller: pontoTuristicoController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Esta sincronizado com o banco remoto?"),
                    ),
                    controller: sicronizadoController,
                  ),
                ),

                // Botão
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _atualizarPoi();
                      },
                      child: const Text("Alterar"),
                    ),
                  ),
                ),


                // Botão
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _apagarPoi();
                      },
                      child: const Text("Remover"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
