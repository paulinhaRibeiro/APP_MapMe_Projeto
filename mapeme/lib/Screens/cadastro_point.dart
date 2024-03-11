import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Localization/geolocation_teste.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:mapeme/Screens/Widgets/divide_text.dart';
import 'package:mapeme/Screens/Widgets/image_input.dart';
//
import 'package:mapeme/Screens/Widgets/text_button.dart';
import 'package:provider/provider.dart';
//
import 'dart:io';

// import 'Widgets/var_global.dart';

// File? imgFile1;
// File? imgteste2;

class CadastroPoi extends StatefulWidget {
  const CadastroPoi({super.key, required this.onUpdateList});
  // recebe a função de atualizar a lista da classe de listagem
  final VoidCallback onUpdateList;

  @override
  State<CadastroPoi> createState() => _CadastroPoiState();
}

class _CadastroPoiState extends State<CadastroPoi>
    with SingleTickerProviderStateMixin {
  File? _pickedImage1;
  File? _pickedImage2;


  void _selectImageAula(
      {File? pickedImage, required int indexImg, bool apagar = false}) {
    setState(() {
      if (indexImg == 1) {
        _pickedImage1 = pickedImage;
      } else if (indexImg == 2) {
        _pickedImage2 = pickedImage;

        // para remover a imagem
      } else if (apagar == true) {
        if (indexImg == 1) {
          _pickedImage1 = pickedImage;
        } else if (indexImg == 2) {
          _pickedImage2 = pickedImage;
        }
      }
    });
  }

  // para controlar o TabBar
  late TabController _tabController;
  // variaveis para pegar o q for digitado nas caixinhas de texto
  final nomeController = TextEditingController();
  final descController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final img1Controller = TextEditingController();
  final img2Controller = TextEditingController();
  // final pontoTuristico = TextEditingController();

  // Para controlar o evento do clique do usuario
  bool clickPontoTuristico = false;
  // final sicronizadoController = TextEditingController();
  //

  // Obtem a instancia da tabela do bd
  var db = GetIt.I.get<ManipuTablePointInterest>();

  //
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Fecha a tela
  _voltarScreen() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastrado com sucesso')),
    );
    Navigator.of(context).pop();
  }

  // Operação de cadastrar BD
  _cadastrarPoi() async {
    // Operação assincrona
    // Cria um novo obj PointInterest
    var p = PointInterest(
      id: 0, // para q o sqlite gerencie o id
      name: nomeController.text,
      description: descController.text,
      latitude: double.parse(latitudeController.text),
      longitude: double.parse(longitudeController.text),
      // img1:  imgFile1 != null ? _pickedImage.toString() : "",
      img1: _pickedImage1 != null ? _pickedImage1.toString() : "",
      img2: _pickedImage2 != null ? _pickedImage2.toString() : "",
      // img2: img2Controller.text,
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
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Cadastro de Rota/POI"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.info),
              text: 'Sobre a Rota',
            ),
            Tab(
              icon: Icon(Icons.location_on),
              text: 'Localização',
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider<GeolocationUser>(
        create: (context) => GeolocationUser(),
        child: Builder(
          builder: (context) {
            final local = context.watch<GeolocationUser>();
            if (local.lat == 0.0 && local.long == 0.0) {
              latitudeController.text = "Carregando...";
              longitudeController.text = "Carregando...";
            } else {
              // Latitude
              latitudeController.text =
                  local.erro == "" ? "${local.lat}" : local.erro;
              // Longitude
              longitudeController.text =
                  local.erro == "" ? "${local.long}" : local.erro;
            }

            return TabBarView(
              controller: _tabController,
              children: [
                // Primeira Aba -> a de Sobre a Rota
                SingleChildScrollView(
                  child: SizedBox(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                label: const Text("Nome"),
                              ),
                              // controlada pela variavel nome
                              controller: nomeController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                label: const Text("Descrição"),
                              ),
                              controller: descController,
                            ),
                          ),

                          // Dividir a tela para a parte das imagens
                          const DividerText(),

                          // passa uma referencia do metodo para o componente
                          ImageInput(onSelectImage: _selectImageAula),

                          //
                          // img1
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 15,
                          //     vertical: 10,
                          //   ),
                          //   child: TextField(
                          //     decoration: InputDecoration(
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       label: const Text("informe a img1"),
                          //     ),
                          //     controller: img1Controller,
                          //   ),
                          // ),

                          //
                          // img2
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 15,
                          //     vertical: 10,
                          //   ),
                          //   child: TextField(
                          //     decoration: InputDecoration(
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       label: const Text("informe a img2"),
                          //     ),
                          //     controller: img2Controller,
                          //   ),
                          // ),

                          const SizedBox(
                            height: 10,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _tabController.animateTo(
                                        1); // Navegar para a aba "Localização"
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 12,
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 63, 6),
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(10),),
                                    elevation: 10,
                                  ),
                                  child: const ScreenTextButtonStyle(
                                      text: "Avançar"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // END Parte 1

                //

                // Segunda Aba -> a de Localização
                SingleChildScrollView(
                  child: SizedBox(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          // latitude
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: TextField(
                              readOnly: true,
                              // enabled: false, // para evitar a edição
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                label: const Text("Longitude"),
                              ),
                              controller: latitudeController,
                            ),
                          ),

                          // Longitude
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: TextField(
                              readOnly: true,
                              // enabled: false, // para evitar a edição
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                label: const Text("Latitude"),
                              ),
                              controller: longitudeController,
                            ),
                          ),

                          // se é rota ou ponto turistico
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
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
                                const Text("É Ponto Turistico")
                              ],
                            ),
                          ),

                          // Botão para cadastrar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                _cadastrarPoi();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 63, 6),
                                elevation: 10,
                                minimumSize: const Size.fromHeight(50),
                              ),
                              child:
                                  const ScreenTextButtonStyle(text: "Salvar"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //
                // END Parte Dois
                //
              ],
            );
          },
        ),
      ),
    );
  }
}