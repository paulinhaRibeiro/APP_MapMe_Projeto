import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_route.dart';
import 'package:mapeme/Screens/CRUD_Screens/cadastro_point.dart';
import 'package:mapeme/Screens/Route/name_id_route.dart';

import 'package:mapeme/Screens/Widgets/divide_text.dart';
import 'package:mapeme/Screens/Widgets/text_button.dart';
import 'package:mapeme/Screens/Widgets/text_field_register.dart';

import '../../Models/route.dart';

// Tela responsavel pela a escolha ou criação de uma nova Rota
class DropPageChoiceRoute extends StatefulWidget {
  const DropPageChoiceRoute({Key? key}) : super(key: key);

  @override
  State<DropPageChoiceRoute> createState() => _DropPageChoiceRouteState();
}

class _DropPageChoiceRouteState extends State<DropPageChoiceRoute> {
  // Opcção escolhida
  final dropValue = ValueNotifier<String>("");
  // Controllers da Rota
  final nomeRouteController = TextEditingController();
  final descRouteController = TextEditingController();
  // Intancia da tabela da rota
  final bd = GetIt.I.get<ManipuTableRoute>();

// lista de nome das rotas
  List<RouteOption> dropOpcoes = [];
  // Para controlar a criação de uma nova Rota
  bool showOutroTextField = false;
  // Texto do botão
  String textButton = "Avançar";
  // Texto AppBar
  String titleAppBar = "Selecionar Rota";

  // Rota Existente
  // Recebe so o id e o nome da rota existente
  late RouteOption nameIdRoute;

  @override
  void initState() {
    super.initState();
    // Carrregar os nomes e os ids da Rota
    loadRoute();
  }

  // função q captura todas as rotas já cadastradas para o usuário escolher uma ou criar uma nova "Nova Rota"
  void loadRoute() async {
    try {
      // Recebe todos os nomes e ids das rotas cadastradas sem repetir o nome
      List<Map<String, dynamic>> routesWithIds =
          await bd.getNameRoutesWithIds();

      setState(() {
        dropOpcoes.clear();
        // A lista recebe todos esses valores
        dropOpcoes.addAll(routesWithIds.map((route) => RouteOption(
            idRoute: route['idRoute'], nameRoute: route['nameRoute'])));
        dropOpcoes.add(RouteOption(idRoute: -1, nameRoute: "Nova Rota"));
      });
    } catch (e) {
      debugPrint("Erro ao carregar o Nome da Rota: $e");
    }
  }

  // Nova Rota
  void _cadastrarRota() async {
    // Passa para a tela de cadastro todos os dados da rota
    var route = RoutesPoint(
      idRoute: 0,
      nameRoute: nomeRouteController.text,
      descriptionRoute: descRouteController.text,
      imgRoute: "sem imagem",
    );
    // Vai para a tela de cadastro com somente os dados da rota para ser criada
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroPoi(
          routePoint: route,
        ),
      ),
    );
  }

  // Rota Existente
  void _routeExist() async {
    // passa para a tela de cadastro só o nome e o id da rota existente
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroPoi(
          idNameRoutePoint: nameIdRoute,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(titleAppBar), //"Cadastrar/Selecionar Rota"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height) -
              MediaQuery.of(context).padding.top,
          child: LayoutBuilder(builder: (_, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * .25,
                  child: Center(
                    child: ValueListenableBuilder(
                      valueListenable: dropValue,
                      builder: (BuildContext context, String value, _) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              DropdownButtonFormField<RouteOption>(
                                isExpanded: true,
                                isDense: true,
                                hint: const Text("Escolha a Rota *"),
                                decoration: InputDecoration(
                                  label: const Text("Rota *"),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                value: (value.isEmpty)
                                    ? null
                                    : dropOpcoes.firstWhere(
                                        (option) => option.nameRoute == value,
                                        orElse: () => dropOpcoes.first),
                                onChanged: (escolha) {
                                  if (escolha!.nameRoute == "Nova Rota") {
                                    setState(() {
                                      showOutroTextField = true;
                                      textButton = "Cadastrar Nova Rota";
                                      titleAppBar = "Cadastrar Rota";
                                    });
                                  } else {
                                    setState(() {
                                      // receber o valor do id
                                      // idRoutePoint = escolha.idRoute;
                                      nameIdRoute = RouteOption(
                                          idRoute: escolha.idRoute,
                                          nameRoute: escolha.nameRoute);
                                      debugPrint(
                                          "nome: ${nameIdRoute.nameRoute} id: ${nameIdRoute.idRoute}");
                                      showOutroTextField = false;
                                      textButton = "Avançar";
                                      titleAppBar = "Selecionar Rota";
                                    });
                                  }
                                  dropValue.value = escolha.nameRoute;
                                },
                                items: dropOpcoes
                                    .map(
                                      (op) => DropdownMenuItem<RouteOption>(
                                        value: op,
                                        child: op.nameRoute != "Nova Rota"
                                            ? Text('Rota: ${op.nameRoute}')
                                            : Row(
                                                children: [
                                                  const Icon(Icons
                                                      .add_circle_outlined),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(op.nameRoute),
                                                ],
                                              ),
                                        // child: Text(op.nameRoute != "Nova Rota" ?
                                        //     'Rota: ${op.nameRoute}' : op.nameRoute),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.0),
                                child: Text(
                                  'Caso a Rota mais condizente com o seu cadastro não estiver na lista, selecione "Nova Rota" e prossiga com o cadastro',
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
                ),
                if (showOutroTextField)
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * .45,
                    child: Column(
                      children: [
                        const DividerText(text: "Cadastrar Rota"),
                        CustomTextField(
                          controller: nomeRouteController,
                          label: "Nome da Rota *",
                          maxLength: 50,
                          validator: (value) =>
                              value!.isEmpty ? "Campo Obrigatório!" : null,
                        ),
                        CustomTextField(
                          controller: descRouteController,
                          label: "Descrição da Rota",
                          maxLength: 200,
                          // validator: (value) => value!.isEmpty ? "Campo Obrigatório!" : null,
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * .16,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (showOutroTextField) {
                              _cadastrarRota();
                            } else {
                              // Se a rota existente for selecionada
                              _routeExist();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            backgroundColor:
                                const Color.fromARGB(255, 0, 63, 6),
                            elevation: 10,
                          ),
                          child: ScreenTextButtonStyle(text: textButton),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nomeRouteController.dispose();
    descRouteController.dispose();
  }
}
