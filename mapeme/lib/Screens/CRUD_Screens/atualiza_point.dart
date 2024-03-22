import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Localization/geolocation_teste.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:provider/provider.dart';

import '../Widgets/camera_galeria/image_input.dart';
import '../Widgets/divide_text.dart';
import '../Widgets/text_button.dart';
import '../Widgets/text_field_register.dart';

class AtualizarCadastroPoi extends StatefulWidget {
  final Function(PointInterest) onUpdate;
  // Para quando abrir a tela já ter o obj carregado
  final PointInterest p;

  const AtualizarCadastroPoi(
      {super.key, required this.p, required this.onUpdate});

  @override
  State<AtualizarCadastroPoi> createState() => _AtualizarCadastroPoiState();
}

class _AtualizarCadastroPoiState extends State<AtualizarCadastroPoi>
    with SingleTickerProviderStateMixin {
  // Obtem a instancia da tabela do bd
  var db = GetIt.I.get<ManipuTablePointInterest>();
  // para controlar o TabBar
  late TabController _tabUpdateController;
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

  // para as variaveis receberem o caminho da imagem
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

  // Função que joga nas caixas de texto o que ja veio do Objeto
  // Isso é chamado sempre que criar a tela
  @override
  void initState() {
    super.initState();
    _tabUpdateController = TabController(length: 3, vsync: this);
    nomeController.text = widget.p.name;
    descController.text = widget.p.description;
    latitudeController.text = widget.p.latitude.toString();
    longitudeController.text = widget.p.longitude.toString();
    _pickedImage1 = widget.p.img1 == "" ? null : File(widget.p.img1);
    _pickedImage2 = widget.p.img2 == "" ? null : File(widget.p.img2);
    // para receber o valor fornecido anteriormente na escolha
    dropValue.value = widget.p.typePointInterest.substring(0, 1).toUpperCase() +
        widget.p.typePointInterest.substring(1).toLowerCase();

    // dropValue.value = widget.p.typePointInterest;
    // recebe o valor de acordo com o valor do campo do bd
    // isTouristPoint = widget.p.turisticPoint == 1 ? true : false;

    // Carrega os tipos de ponto de interesse ao inicializar o estado
    loadPointInterestTypes();
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

  _voltarScreen() {
    _aviso("Cadastrado Atualizado com Sucesso");
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

  _atualizarPoi() async {
    var p = PointInterest(
      id: widget.p.id,
      foreignidRoute: null, // recebe o id quando abriu a tela - Construtor
      name: nomeController.text,
      description: descController.text,
      latitude: double.parse(latitudeController.text),
      longitude: double.parse(longitudeController.text),
      img1: _pickedImage1 != null ? _pickedImage1!.path : "",
      img2: _pickedImage2 != null ? _pickedImage2!.path : "",
      typePointInterest: dropValue.value != "Outro"
          ? dropValue.value.toUpperCase()
          : typePointController.text.toUpperCase(),
      // img1: img1Controller.text,
      // img2: img2Controller.text,
      // turisticPoint: isTouristPoint ? 1 : 0,
      // receber o valor dela mesmo
      synced: widget.p.synced,
    );
    await db.updatePointInterest(p);
    widget.onUpdate(p);
    _voltarScreen();
  }

  void _submitUpdateForm() {
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
    // chama a função de atualizar
    _atualizarPoi();
  }

  @override
  Widget build(BuildContext context) {
    // local = Provider.of<GeolocationUser>(context);
    // local = context.watch<GeolocationUser>();
    // debugPrint("${local.lat} - ${local.long}");

    return Scaffold(
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Editar Ponto de Interesse"),
        bottom: TabBar(
          controller: _tabUpdateController,
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

            return TabBarView(
              controller: _tabUpdateController,
              children: [
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
                          label: "Descrição ",
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
                                  _tabUpdateController.animateTo(
                                      1); // Navegar para a aba "Tipo do ponto"
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
                  // ),
                  // ),
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
                                child: Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      // Define o tamanho do DropdownButtonFormField para preencher o espaço disponível horizontalmente
                                      isExpanded: true,
                                      // Reduz a altura do DropdownButtonFormField
                                      isDense: true,

                                      hint: const Text(
                                          "Escolha o Tipo do Ponto de Interesse *"),
                                      decoration: InputDecoration(
                                        label: const Text(
                                            "Tipo do Ponto de Interesse *"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 13.0),
                                      child: Text(
                                        'Caso o item mais condizente com o seu cadastro não estiver na lista, selecione "Outro" e insira manualmente no campo de texto.',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 89, 89, 89)),
                                      ),
                                    ),
                                  ],
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
                                    _tabUpdateController.animateTo(
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
                    child: SizedBox(
                      child: Center(
                        child: Column(
                          children: [
                            // LATITUDE e LONGITUDE são parametros sem o usuário poder alterar (automatico)
                            // campo LATITUDE do ponto de interesse
                            CustomTextField(
                              controller: latitudeController,
                              label: "Latitude *",
                            ),

                            // Botão para Gerar nova localização
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (local.lat == null && local.long == null) {
                                    latitudeController.text = "Carregando...";
                                    longitudeController.text = "Carregando...";
                                  } else {
                                    // Latitude
                                    latitudeController.text = local.erro == ""
                                        ? "${local.lat}"
                                        : local.erro;
                                    // Longitude
                                    longitudeController.text = local.erro == ""
                                        ? "${local.long}"
                                        : local.erro;
                                  }
                                },
                                icon: const Icon(Icons.edit_location_alt),
                                label: const Text('Gerar Nova Localização'),
                              ),
                            ),

                            // campo LONGITUDE do ponto de interesse
                            CustomTextField(
                              controller: longitudeController,
                              label: "Longitude *",
                            ),

                            // se é rota ou ponto turistico
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
                                  _submitUpdateForm();
                                  // _atualizarPoi();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 63, 6),
                                  elevation: 10,
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const ScreenTextButtonStyle(
                                    text: "Salvar Alterações"),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  @override
  void dispose() {
    nomeController.dispose();
    descController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    typePointController.dispose();
    _tabUpdateController.dispose();
    super.dispose();
  }
}
