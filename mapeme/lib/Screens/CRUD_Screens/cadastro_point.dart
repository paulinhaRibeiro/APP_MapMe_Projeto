import 'package:flutter/material.dart';
// Arquivos
import 'dart:io';
// Gerenciador de depen
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Localization/geolocation_teste.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:mapeme/Models/route.dart';
import 'package:mapeme/Screens/Widgets/divide_text.dart';
import 'package:mapeme/Screens/Widgets/camera_galeria/image_input.dart';
//
import 'package:mapeme/Screens/Widgets/text_button.dart';
import 'package:provider/provider.dart';

import '../../BD/table_route.dart';
import '../Route/name_id_route.dart';
import '../Widgets/text_field_register.dart';
import 'tab_listagens.dart';

class CadastroPoi extends StatefulWidget {
  const CadastroPoi(
      {super.key, this.onUpdateList, this.routePoint, this.idNameRoutePoint});
  // recebe a função de atualizar a lista da classe de listagem
  final VoidCallback? onUpdateList;
  // Definindo um valor padrão para routePoint - cadastro da rota
  final RoutesPoint? routePoint;
  // armazena o nome e o id da rota
  final RouteOption? idNameRoutePoint;

  @override
  State<CadastroPoi> createState() => _CadastroPoiState();
}

class _CadastroPoiState extends State<CadastroPoi>
    with SingleTickerProviderStateMixin {
  // Obtem a instancia da tabela do bd
  var db = GetIt.I.get<ManipuTablePointInterest>();

  var dbRoute = GetIt.I.get<ManipuTableRoute>();
  // para controlar o TabBar
  late TabController _tabController;

  // variaveis para pegar o q for digitado nas caixinhas de texto
  final nomeController = TextEditingController();
  final descController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // Type do point
  // para pegar a escolha ou o valor digitado
  final typePointController = TextEditingController();
  final dropValue = ValueNotifier("");
  // Lista vazia para ser preenchida posteriormente
  List<String> dropOpcoes = [];
  bool showOutroTextField = false;
  // id da rota
  int? routeId;
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
    // debugPrint("ID Da rota selecionada: ${widget.idNameRoutePoint!.idRoute}");
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

  // restartar o cadastro
  _restartRegisterRoutePoint() async {
    String txt = "Deseja Cadastrar mais um ponto a esta Rota:";
    if (widget.idNameRoutePoint != null) {
      txt =
          "$txt ${widget.idNameRoutePoint!.nameRoute}";
    } else {
      txt =
          "$txt ${widget.routePoint!.nameRoute}";
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            txt,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: <Widget>[
            // se clicar em não só volta para a listagem
            TextButton(
              onPressed: () {
                // Fechar e navegar para a listagem
                Navigator.of(context).pop(true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListagemDados()));
              },
              child: const Text(
                "Não",
                style: TextStyle(
                  fontSize: 16.0,
                  // color: Color.fromARGB(255, 91, 91, 91),
                ),
              ),
            ),

            // Caso clicar em sim vai voltar para criar um novo registro
            ElevatedButton(
              onPressed: () {
                nomeController.text = "";
                descController.text = "";
                // latitudeController.text = "";
                // longitudeController= "";

                // imagem
                _pickedImage1 = null;
                _pickedImage2 = null;

                // restartar a lista de tipos de pontos
                loadPointInterestTypes();
                dropValue.value = "";
                _tabController.animateTo(0);

                // para não aparecer o campo de nome e descrição do typo de point
                showOutroTextField = false;
                typePointController.text = "";

                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Sim",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        );
      },
    );
  }

  // Cadastrar uma rota existente ou o foreignidRoute do point recebe o id da rota
  _cadastraRoutePoint() async {
    
    // rota existente captura só o id dela
    if (widget.idNameRoutePoint != null) {
      routeId = widget.idNameRoutePoint!.idRoute;
    }
    // cadastrar um nova rota e receber o id dela
    else if (widget.idNameRoutePoint == null &&
        widget.routePoint!.idRoute == 0) {
      routeId = await dbRoute.insertRoute(widget.routePoint!);
      debugPrint("id da nova rota $routeId");
      // o id que era zero passa a ser o id do novo cadastro de rota 
      widget.routePoint!.idRoute = routeId!;
    }

    // Cria um novo obj PointInterest
    var p = PointInterest(
      id: 0, // para q o sqlite gerencie o id
      foreignidRoute: routeId,
      name: nomeController.text,
      description: descController.text,
      latitude: double.parse(latitudeController.text),
      longitude: double.parse(longitudeController.text),
      img1: _pickedImage1 != null ? _pickedImage1!.path : "",
      img2: _pickedImage2 != null ? _pickedImage2!.path : "",
      typePointInterest: dropValue.value != "Outro"
          ? dropValue.value.toUpperCase()
          : typePointController.text.toUpperCase(),
      synced: 0, 
    );

    await db.insertPointInterest(p); // converte para toMap e grava no sqlite
    // chama o card para restartar o cadastro
    _restartRegisterRoutePoint();
  }

  // Operação de cadastrar BD
  _cadastrarPoi() async {
    // cria o ponto de interesse sem ser ligado a nenhuma rota
    if (widget.routePoint == null && widget.idNameRoutePoint == null) {
      // Cria um novo obj PointInterest
      var p = PointInterest(
        id: 0, // para q o sqlite gerencie o id
        foreignidRoute: null,
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
      widget.onUpdateList!();

      // Fecha a tela
      _voltarScreen();
    } else {
      // ponto de interesse ligado a uma rota já existente ou nova
      _cadastraRoutePoint();
    }
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

  // valida os campos e chama a função de cadastrar
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

  @override
  void dispose() {
    nomeController.dispose();
    descController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    typePointController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
