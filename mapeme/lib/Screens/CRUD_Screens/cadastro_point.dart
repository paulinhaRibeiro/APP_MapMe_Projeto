import 'package:flutter/material.dart';
// Arquivos
import 'dart:io';
// Gerenciador de depen
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Localization/geolocation.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:mapeme/Models/route.dart';
import 'package:mapeme/Screens/Widgets/divide_text.dart';
import 'package:mapeme/Screens/Widgets/camera_galeria/image_input.dart';
//
import 'package:mapeme/Screens/Widgets/text_button.dart';

import '../../BD/table_route.dart';
import '../Route/name_id_route.dart';
import '../Widgets/utils/informativo.dart';
import '../Widgets/text_field_register.dart';
import 'tab_listagens.dart';

class CadastroPoi extends StatefulWidget {
  const CadastroPoi(
      {super.key, this.onUpdateList, this.routePoint, this.idNameRoutePoint});
  // Quando é ligado a nenhuma rota, só recebe a função de callback
  // recebe a função de atualizar a lista da classe de listagem
  final VoidCallback? onUpdateList;

  //        ROTA
  // CADASTRAR UMA NOVA ROTA e o ponto
  final RoutesPoint? routePoint;
  // ROTA EXISTENTE -
  // armazena só nome e o id da rota (não tem a descrição), para perguntar
  // se quer cadastrar outro item a mesma rota
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
  // captura a escolha do tipo de ponto
  final dropValue = ValueNotifier("");
  // Lista vazia para ser preenchida posteriormente com os tipos dos pontos
  List<String> dropOpcoes = [];
  // para criar um novo tipo de ponto
  bool showOutroTextField = false;
  // id da rota
  int? routeId;
  //

  // variaveis para pegar as imagem escolhidas
  File? _pickedImage1;
  File? _pickedImage2;

  // Recebe as imgs - Callback
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
    // Chama a função que captura a geolocalização do usuario
    _initGeolocation();
  }

  void _initGeolocation() async {
    latitudeController.text = "Carregando...";
    longitudeController.text = "Carregando...";
    // Inicializa
    GeolocationUser geolocationUser = GeolocationUser();
    // Chama a função responsavel pela a geolocalização
    await geolocationUser.getPosition();
    // verifica se o estado está montado antes de chamar setState
    if (mounted) {
      // Só chama setState quando o widget ainda estiver na árvore de widgets e evitará o erro de setState called after dispose()
      if (geolocationUser.lat != null && geolocationUser.long != null) {
        // Muda o estado do latitudeController e longitudeController para o valor de lat e long ou então o erro
        setState(() {
          latitudeController.text = geolocationUser.erro == ""
              ? "${geolocationUser.lat}"
              : geolocationUser.erro;
          longitudeController.text = geolocationUser.erro == ""
              ? "${geolocationUser.long}"
              : geolocationUser.erro;
        });
      }
    }
  }

  // captura todos os tipos de pontos de interesse
  void loadPointInterestTypes() async {
    try {
      // Recebe todos os tipos dos pontos de interesse cadastrados sem repetição
      List<String> types = await db.getPointInterestTypes();
      setState(() {
        // Limpar a lista atual
        dropOpcoes.clear();
        // Adicionar os tipos recuperados do banco de dados
        dropOpcoes.addAll(types.map((type) =>
            type.substring(0, 1).toUpperCase() +
            type.substring(1).toLowerCase()));

        // Só vai conter "Tipo não identificado" se o cadastro for de um ponto ligado a uma rota
        if (widget.routePoint != null || widget.idNameRoutePoint != null) {
          // Adicionar o campo de ponto não identificado somente se não existir na lista
          if (!dropOpcoes.contains("Tipo não identificado")) {
            dropOpcoes.add("Tipo não identificado");
          }
        }
        // Se for um ponto que não é ligado a uma rota
        else if (widget.routePoint == null && widget.idNameRoutePoint == null) {
          // Verifica se o "Tipo não identificado" existi na lista
          if (dropOpcoes.contains("Tipo não identificado")) {
            // Apaga, caso exista
            dropOpcoes.remove("Tipo não identificado");
          }
        }

        // // Adicionar o campo de ponto não identificado somente se não existir na lista
        // if (!dropOpcoes.contains("Tipo não identificado")) {
        //   dropOpcoes.add("Tipo não identificado");
        // } else {
        //   //se o "Tipo não identificado" exitir na lista
        //   // e se não for o cadastro ligado a uma rota -> ou seja um ponto de interesse que não é ligado a nenhuma rota
        //   // Pq o Ponto de interesse devem ter um tipo em especifico. Não pode ser Tipo não identificado
        //   if (widget.routePoint == null && widget.idNameRoutePoint == null) {
        //     dropOpcoes.remove("Tipo não identificado");
        //   }
        // }

        // Adicionar o campo Novo Tipo de Ponto
        dropOpcoes.add("Novo Tipo de Ponto");
      });
    } catch (e) {
      debugPrint("Erro ao carregar tipos de ponto de interesse: $e");
    }
  }

  // AlertDialog para restartar o cadastro
  _restartRegisterRoutePoint() async {
    String txt = "Deseja cadastrar mais um ponto a esta rota ";
    if (widget.idNameRoutePoint != null) {
      txt = '$txt "${widget.idNameRoutePoint!.nameRoute}"?';
    } else {
      txt = '$txt "${widget.routePoint!.nameRoute}"?';
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
                Aviso.showSnackBar(context, "Cadastrado com Sucesso");

                // Tem q ver essa questão
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                // Volta para atela de listagem
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
                // Restarta todos os campos
                nomeController.text = "";
                descController.text = "";

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

                // restarta a localização
                _initGeolocation();

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

  // Cadastrar a Rota  e o point da Rota
  // Cadastrar uma rota existente ou o foreignidRoute do point recebe o id da rota
  _cadastraRoutePoint() async {
    // ROTA EXISTENTE
    // se idNameRoutePoint não for nulo - ele é uma Rota que já existe
    if (widget.idNameRoutePoint != null) {
      // Recebe o id dessa rota que já existe
      routeId = widget.idNameRoutePoint!.idRoute;
    }
    // CADASTRAR NOVA ROTA
    // Se a rota existente for nulo (widget.idNameRoutePoint)
    // e widget.routePoint!.idRoute for igual a zeo, significa que é uma rota nova
    // faz essa validação "widget.routePoint!.idRoute == 0" para que quando resertar o cadastro não ter perigo de criar outra nova rota
    else if (widget.idNameRoutePoint == null &&
        widget.routePoint!.idRoute == 0) {
      // Cadastra a rota e o "routeId" recebe o id dela
      routeId = await dbRoute.insertRoute(widget.routePoint!);
      debugPrint("id da nova rota $routeId");
      // o id que era zero passa a ser o id do novo cadastro de rota
      // Assim não entrará masi nesse else if quando resetar o cadastro, vai só para o
      // if de rota existente
      widget.routePoint!.idRoute = routeId!;
    }

    // Cria um novo obj PointInterest
    var p = PointInterest(
      id: 0, // para q o sqlite gerencie o id
      // Recebe o id da rota
      foreignidRoute: routeId,
      name: nomeController.text,
      description: descController.text,
      latitude: double.parse(latitudeController.text),
      longitude: double.parse(longitudeController.text),
      img1: _pickedImage1 != null ? _pickedImage1!.path : "",
      img2: _pickedImage2 != null ? _pickedImage2!.path : "",
      typePointInterest: dropValue.value != "Novo Tipo de Ponto"
          ? dropValue.value.toUpperCase()
          : typePointController.text.toUpperCase(),
      synced: 0,
    );

    await db.insertPointInterest(p); // converte para toMap e grava no sqlite
    // chama o card para restartar o cadastro
    _restartRegisterRoutePoint();
  }

  // Operação de cadastrar BD o Point de Interesse
  _cadastrarPoi() async {
    // cria o ponto de interesse sem ser ligado a nenhuma rota
    // Ponto de interesse que não é ligado a nenhuma rota
    // Se não for passado valores de uma rota existente (widget.idNameRoutePoint)
    // e nem de uma nova Rota (widget.routePoint)
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
        typePointInterest: dropValue.value != "Novo Tipo de Ponto"
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
    }
    //Se for uma Rota existente ou uma nova Rota
    else {
      // ponto de interesse ligado a uma rota já existente ou nova
      _cadastraRoutePoint();
    }
  }

  // Fecha a tela e mostrar mensagem de sucesso
  _voltarScreen() {
    Aviso.showSnackBar(context, "Cadastrado com Sucesso");
    // _aviso("Cadastrado com Sucesso");
    Navigator.of(context).pop();
  }

  // _aviso(String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Center(
  //         child: Text(
  //           msg,
  //           style: const TextStyle(
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // valida os campos e chama a função de cadastrar
  void _submitForm() {
    // ignore: unused_local_variable
    double posiLat;

    if (nomeController.text.isEmpty ||
        latitudeController.text.isEmpty ||
        longitudeController.text.isEmpty ||
        dropValue.value == "") {
      Aviso.showSnackBar(context,
          "Os Campos Nome, Tipo, Latitude e Longitude são obrigatórios");
      // _aviso("Os Campos Nome, Tipo, Latitude e Longitude são obrigatórios");
      return;
    }
    try {
      posiLat = double.parse(latitudeController.text);
    } catch (e) {
      Aviso.showSnackBar(context,
          "Por favor, Certifique-se de que o serviço de localização está ativo e aguarde o carregamento.");
      // _aviso( "Por favor, Certifique-se de que o serviço de localização está ativo e aguarde o carregamento.");
      return;
    }
    // chama a função de cadastrar se os campos forem validos
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
      body: TabBarView(
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
                          child: const ScreenTextButtonStyle(text: "Avançar"),
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                value: (value.isEmpty) ? null : value,
                                onChanged: (escolha) {
                                  if (escolha == "Novo Tipo de Ponto") {
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
                                        child: op != "Novo Tipo de Ponto"
                                            ? Text(op)
                                            : Row(
                                                children: [
                                                  const Icon(Icons
                                                      .add_circle_outlined),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(op),
                                                ],
                                              ),
                                        // child: Text(op),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.0),
                                child: Text(
                                  'Caso o item mais condizente com o seu cadastro não estiver na lista, selecione "Novo Tipo de Ponto" e insira manualmente no campo de texto.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 89, 89, 89)),
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
                                content:
                                    Text('Por favor, digite o tipo do ponto'),
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
                          child: const ScreenTextButtonStyle(text: "Avançar"),
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
                        backgroundColor: const Color.fromARGB(255, 0, 63, 6),
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
