import 'package:flutter/material.dart';

// para geolocalizacao
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';

//
import 'package:mapeme/Localization/geolocalization.dart';

//
class CadastroPoi extends StatefulWidget {
  const CadastroPoi({super.key, required this.onUpdateList});
  // recebe a função de atualizar a lista da classe de listagem
  final VoidCallback onUpdateList;

  @override
  State<CadastroPoi> createState() => _CadastroPoiState();
}

class _CadastroPoiState extends State<CadastroPoi> {
  // variaveis para pegar o q for digitado nas caixinhas de texto
  final nome = TextEditingController();
  final desc = TextEditingController();
  final latitude = TextEditingController();
  final longitude = TextEditingController();
  final img1 = TextEditingController();
  final img2 = TextEditingController();
  // final pontoTuristico = TextEditingController();

  // Para controlar o evento do clique do usuario
  bool clickPontoTuristico = false;
  final sicronizado = TextEditingController();
  //

  // Obtem a instancia da tabela do bd
  var db = GetIt.I.get<ManipuTablePointInterest>();

  //
  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  void _initLocation() async {
    // Inicializa os controladores com "Carregando..."
    latitude.text = "Carregando...";
    longitude.text = "Carregando...";

    // Obtém a localização atual ao iniciar a tela
    Position? position = await obterLocalizacaoAtual();
    if (position != null) {
      setState(() {
        latitude.text = position.latitude.toString();
        longitude.text = position.longitude.toString();
      });
    }
  }

  // Fecha a tela
  _voltarScreen() {
    Navigator.of(context).pop();
  }

  // Operação de cadastrar BD
  _cadastrarPoi() async {
    // Operação assincrona
    // Cria um novo obj PointInterest
    var p = PointInterest(
      id: 0, // para q o sqlite gerencie o id
      name: nome.text,
      description: desc.text,
      latitude: double.parse(latitude.text),
      longitude: double.parse(longitude.text),
      img1: img1.text,
      img2: img2.text,
      // turisticPoint: int.parse(pontoTuristico.text),
      turisticPoint: clickPontoTuristico ? 1 : 0,

      // é zero pq sempre quando cadastrar via verificar se possui conexão com a internet, se tiver, vai mandar para o bd remoto e marcar com 1 (sincronizado)
      synced: 0, //int.parse(sicronizado.text),
    );

    await db.insertPointInterest(p); // converte para toMap e grava no sqlite
    // acessa a função de callback - executa a funcao do outro arquivo - Atualiza a lista de pontos de interesse
    widget.onUpdateList();
    // Fecha a tela
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
                    // controlada pela variavel nome
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
                    readOnly: true,
                    // enabled: false, // para evitar a edição
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
                    // enabled: false, // para evitar a edição
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
                  child: Row(
                    children: [
                      Checkbox(
                          value: clickPontoTuristico,
                          onChanged: (value) {
                            setState(() {
                              clickPontoTuristico = value!;
                            });
                          }),
                      const Text("É um ponto turistico")
                    ],
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
                        _cadastrarPoi();
                        // _localizacaoAtual();
                      },
                      child: const Text("Salvar"),
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
