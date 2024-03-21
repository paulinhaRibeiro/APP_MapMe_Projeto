import 'package:flutter/material.dart';
// Arquivos
import 'dart:io';
// Gerenciador de depen
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Localization/geolocation_teste.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:mapeme/Screens/Widgets/divide_text.dart';
import 'package:mapeme/Screens/Widgets/camera_galeria/image_input.dart';
//
import 'package:mapeme/Screens/Widgets/text_button.dart';
import 'package:provider/provider.dart';

import '../Widgets/text_field_register.dart';

class CadastroPoi extends StatefulWidget {
  const CadastroPoi({super.key, required this.onUpdateList});
  // recebe a função de atualizar a lista da classe de listagem
  final VoidCallback onUpdateList;

  @override
  State<CadastroPoi> createState() => _CadastroPoiState();
}

class _CadastroPoiState extends State<CadastroPoi>
    with SingleTickerProviderStateMixin {
  // Obtem a instancia da tabela do bd
  var db = GetIt.I.get<ManipuTablePointInterest>();
  // para controlar o TabBar
  late TabController _tabController;

  // variaveis para pegar o q for digitado nas caixinhas de texto
  final nomeController = TextEditingController();
  final descController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // Type do point
  // para pegar a escola ou o valor digitado
  final typePointController = TextEditingController();
  final dropValue = ValueNotifier("");
  // Lista vazia para ser preenchida posteriormente
  List<String> dropOpcoes = [];
  bool showOutroTextField = false;
  //

  // Para controlar o evento do clique do usuario
  // bool isTouristPoint = false;

  // variaveis para pegar as imagem escolhidas
  File? _pickedImage1;
  File? _pickedImage2;

  void _selectImage(
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

  //
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Carrega os tipos de ponto de interesse ao inicializar o estado
    loadPointInterestTypes();
    latitudeController.text = "Carregando...";
    longitudeController.text = "Carregando...";
  }

  void loadPointInterestTypes() async {
    try {
      List<String> types = await db.getPointInterestTypes();
      setState(() {
        // Limpar a lista atual
        dropOpcoes.clear();
        // Adicionar os tipos recuperados do banco de dados
        dropOpcoes.addAll(types.map((type) =>
            type.substring(0, 1).toUpperCase() +
            type.substring(1).toLowerCase()));
        // dropOpcoes.addAll(types);

        // Adicionar o campo Outro
        dropOpcoes.add("Outro");
      });
    } catch (e) {
      debugPrint("Erro ao carregar tipos de ponto de interesse: $e");
    }
  }

  void _submitForm() {
    // ignore: unused_local_variable
    double posiLat;

    if (nomeController.text.isEmpty ||
        latitudeController.text.isEmpty ||
        longitudeController.text.isEmpty ||
        dropValue.value == "") {
      _aviso("Os Campos Nome, Tipo, Latitude e Longitude são obrigatórios");
      return;
    }
    try {
      posiLat = double.parse(latitudeController.text);
    } catch (e) {
      _aviso(
          "Por favor, Certifique-se de que o serviço de localização está ativo e aguarde o carregamento.");
      return;
    }
    // chama a função de cadastrar
    _cadastrarPoi();
  }

  // Operação de cadastrar BD
  _cadastrarPoi() async {
    // Cria um novo obj PointInterest
    var p = PointInterest(
      id: 0, // para q o sqlite gerencie o id
      name: nomeController.text,
      description: descController.text,
      latitude: double.parse(latitudeController.text),
      longitude: double.parse(longitudeController.text),
      img1: _pickedImage1 != null ? _pickedImage1!.path : "",
      img2: _pickedImage2 != null ? _pickedImage2!.path : "",
      typePointInterest: dropValue.value != "Outro"
          ? dropValue.value.toUpperCase()
          : typePointController.text.toUpperCase(),
      // turisticPoint: isTouristPoint ? 1 : 0,

      // é zero pq sempre quando cadastrar via verificar se possui conexão com a internet, se tiver, vai mandar para o bd remoto e marcar com 1 (sincronizado)
      synced: 0, //int.parse(sicronizado.text),
    );

    await db.insertPointInterest(p); // converte para toMap e grava no sqlite
    // acessa a função de callback - executa a funcao do outro arquivo - Atualiza a lista de pontos de interesse
    widget.onUpdateList();

    // Fecha a tela
    _voltarScreen();
  }

  // Fecha a tela e mostrar mensagem de sucesso
  _voltarScreen() {
    _aviso("Cadastrado com Sucesso");
    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Cadastro de Ponto de Interesse"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.info),
              text: 'Sobre o Ponto',
            ),
            Tab(
              icon: Icon(Icons.category),
              text: 'Tipo do Ponto',
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
            if (local.lat != null && local.long != null) {
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
//

                // ------ Primeira

//
                // Primeira Aba -> a de Sobre a Rota
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 10),
                        // campo NOME do ponto de interesse
                        CustomTextField(
                          controller: nomeController,
                          label: "Nome *",
                          maxLength: 50,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Campo Obrigatório!";
                            }
                            return null;
                          },
                        ),

                        // campo DESCRIÇÂO do ponto de interesse
                        CustomTextField(
                          controller: descController,
                          label: "Descrição",
                          maxLength: 200,
                        ),

                        // Dividir a tela para a parte das imagens
                        const DividerText(
                          text: "Cadastrar Imagem",
                        ),

                        // IMAGEM passa uma referencia do metodo para o componente - callback
                        ImageInput(
                          onSelectImage: _selectImage,
                          storedImageSalva1: _pickedImage1,
                          storedImageSalva2: _pickedImage2,
                        ),

                        const SizedBox(height: 5),

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
                                      1); // Navegar para a aba "Type Point"
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 63, 6),
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
//

                // ------ Segunda

//
                // Segunda Aba -> escolher o tipo do ponto
                // Para escolher qual é o Ponto
                // DropPageTypePoint(controllerTab: _tabController),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        
                        Center(
                          child: ValueListenableBuilder(
                            valueListenable: dropValue,
                            builder: (BuildContext context, String value, _) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: DropdownButtonFormField<String>(
                                  // Define o tamanho do DropdownButtonFormField para preencher o espaço disponível horizontalmente
                                  isExpanded: true,
                                  // Reduz a altura do DropdownButtonFormField
                                  isDense: true, 

                                  hint: const Text("Escolha o Tipo do Ponto de Interesse *"),
                                  decoration: InputDecoration(
                                    helperText: 'Caso o item mais condizente com o seu cadastro não estiver na lista, selecione "Outro" e insira manualmente no campo de texto.',
                                    helperMaxLines: 5,
                                    label: const Text("Tipo do Ponto de Interesse *"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  value: (value.isEmpty) ? null : value,
                                  onChanged: (escolha) {
                                    if (escolha == "Outro") {
                                      setState(() {
                                        showOutroTextField = true;
                                      });
                                    } else {
                                      setState(() {
                                        showOutroTextField = false;
                                      });
                                    }
                                    dropValue.value = escolha.toString();
                                  },
                                  items: dropOpcoes
                                      .map(
                                        (op) => DropdownMenuItem(
                                          value: op,
                                          child: Text(op),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                          ),
                        ),
                        if (showOutroTextField)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: CustomTextField(
                              controller: typePointController,
                              label: "Digite o Tipo do Ponto de Interesse *",
                              maxLength: 50,
                              exampleText: "Ex: Ponto turístico",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Campo Obrigatório!";
                                }
                                return null;
                              },
                            ),
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
                                  if (showOutroTextField &&
                                          typePointController.text.isEmpty ||
                                      dropValue.value == "") {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Por favor, digite o tipo do ponto'),
                                    ));
                                  } else {
                                    _tabController.animateTo(
                                        2); // Navegar para a aba "Localização"
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 63, 6),
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
//

                // ------ Terceira

//
                // Terceira Aba -> a de Localização
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // LATITUDE e LONGITUDE são parametros sem o usuário poder alterar (automatico)
                        // campo LATITUDE do ponto de interesse
                        CustomTextField(
                          controller: latitudeController,
                          label: "Latitude *",
                        ),

                        // campo LONGITUDE do ponto de interesse
                        CustomTextField(
                          controller: longitudeController,
                          label: "Longitude *",
                        ),

                        // // se é rota ou ponto turistico
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 15,
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Checkbox(
                        //           value: isTouristPoint,
                        //           onChanged: (value) {
                        //             setState(() {
                        //               isTouristPoint = value!;
                        //             });
                        //           }),
                        //       const Text("É Ponto Turistico.")
                        //     ],
                        //   ),
                        // ),

                        const SizedBox(height: 10),

                        // Botão para cadastrar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              _submitForm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 63, 6),
                              elevation: 10,
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const ScreenTextButtonStyle(text: "Salvar"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
