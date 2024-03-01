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

  final nome = TextEditingController();
  final desc = TextEditingController();
  final latitude = TextEditingController();
  final longitude = TextEditingController();
  final img1 = TextEditingController();
  final img2 = TextEditingController();
  final pontoTuristico = TextEditingController();
  final sicronizado = TextEditingController();

  //

  var db = GetIt.I.get<ManipuTablePointInterest>();

  @override
  // Função que joga nas caixas de texto o que ja veio do Objeto
  // Isso é chamado sempre que criar a tela
  void initState(){
    super.initState();
    nome.text = widget.p.name;
    desc.text = widget.p.description;
    latitude.text = widget.p.latitude.toString();
    longitude.text = widget.p.longitude.toString();
    img1.text = widget.p.img1;
    img2.text = widget.p.img2;
    pontoTuristico.text = widget.p.turisticPoint.toString();
    sicronizado.text = widget.p.synced.toString();

  }

  _voltarScreen(){
    Navigator.of(context).pop();
  }

  _atualizarPoi() async {
    var p = PointInterest(
        id: widget.p.id, // recebe o id quando abriu a tela - Construtor
        name: nome.text,
        description: desc.text,
        latitude: double.parse(latitude.text),
        longitude: double.parse(longitude.text),
        img1: img1.text,
        img2: img2.text,
        turisticPoint: int.parse(pontoTuristico.text),
        synced: int.parse(sicronizado.text));
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
                    controller: nome,
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
                    controller: desc,
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
                      label: Text("informe a longitude"),
                    ),
                    controller: latitude,
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
                      label: Text("informe a latitude"),
                    ),
                    controller: longitude,
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
                    controller: img1,
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
                    controller: img2,
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
                    controller: pontoTuristico,
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
                    controller: sicronizado,
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
