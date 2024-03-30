import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';
// tela de atualiza
// import 'package:mapeme/Screens/atualiza_point.dart';
// tela de cadastro
import 'package:mapeme/Screens/CRUD_Screens/cadastro_point.dart';
import 'package:mapeme/Screens/CRUD_Screens/listagem_point_interesse.dart';
import 'package:mapeme/Screens/Route/drop_down_choice_route.dart';
import 'package:mapeme/Screens/Route/listagem_route.dart';
// texto do botão
import 'package:mapeme/Screens/Widgets/text_button.dart';

// rota
import '../../BD/table_route.dart';
import '../../Models/route.dart';

class ListagemDados extends StatefulWidget {
  const ListagemDados({super.key});

  @override
  State<ListagemDados> createState() => _ListagemDadosState();
}

class _ListagemDadosState extends State<ListagemDados>
    with SingleTickerProviderStateMixin {
  var bd = GetIt.I.get<ManipuTablePointInterest>();
  // lista de pontos de interesse
  late Future<List<PointInterest>> items;

  // Rota
  var bdRoute = GetIt.I.get<ManipuTableRoute>();
  // lista de rotas
  late Future<List<RoutesPoint>> itemsRoute;
  // para controlar o TabBar
  late TabController _tabListagemController;


  @override
  // metodo disparado quando criar essa tela
  void initState() {
    super.initState();
    _tabListagemController = TabController(length: 2, vsync: this);

    items = bd.getPointInterest();
    // Rota
    itemsRoute = bdRoute.getRoute();
  }

  // sempre que tiver uma modificação, renderiza o componente
  // essa função é executada por callback - vai ser executada em outras classes (arquivos) por callback
  // quando cadastrar chama ela para atualizar a lista
  // executada posteriormente e não quando criada no arquivo original
  atualizarDados() {
    setState(() {
      items = bd.getPointInterest();
      itemsRoute = bdRoute.getRoute();
    });
  }

  _escolhaRotaPoint() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            // textAlign: TextAlign.center,
            "Faz parte de uma Rota?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: <Widget>[
            // Se não fizer parte de uma rota vai para a tela de cadastrar um ponto de interesse que é algum ponto turistico por exemplo: sem tá ligado a uma rota
            TextButton(
              onPressed: () {
                // Fechar e navegar para a proxima pagina
                Navigator.of(context).pop(true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CadastroPoi(onUpdateList: atualizarDados)));
              },
              child: const Text(
                "Não",
                style: TextStyle(
                  fontSize: 16.0,
                  // color: Color.fromARGB(255, 91, 91, 91),
                ),
              ),
            ),

            // Caso clicar em sim vai ser direcionado a tela de escolher a rota ou criar uma
            ElevatedButton(
              onPressed: () {
                // const DropPageChoiceRoute();

                Navigator.of(context).pop(true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DropPageChoiceRoute()));

                // Chamar a pag da rota
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

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      // retirar o icone da seta que é gerado automaticamente
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text(
        "Listagem",
        textAlign: TextAlign.center,
      ),
      bottom: TabBar(
        controller: _tabListagemController,
        tabs: const [
          Tab(
            icon: Icon(Icons.alt_route_outlined),
            text: 'Rotas',
          ),
          Tab(
            icon: Icon(Icons.share_location_outlined),
            text: 'Pontos de Interesse',
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height) -
            MediaQuery.of(context).padding.top,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabListagemController,
                    children: [
                      // Rotas
                      SingleChildScrollView(
                        child: SizedBox(
                          // color: Colors.amber,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * .89,
                          child: Center(
                            child: ListagemRoute(
                              itemsRoute: itemsRoute,
                              onUpdateListaRoute: atualizarDados,
                            ),
                          ),
                        ),
                      ),

                      // Pontos de interesse
                      SingleChildScrollView(
                        child: SizedBox(
                          // altura - pegar 89% da tela disponivel
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * .89,
                          child: Center(
                            child: ListagemPointInteresse(
                              itemsPoint: items,
                              onUpdateListaPoint: atualizarDados,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _escolhaRotaPoint();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                      elevation: 10,
                      minimumSize: const Size.fromHeight(55),
                    ),
                    icon: const Icon(
                      Icons.add_location_alt_outlined,
                      color: Colors.white,
                    ),
                    label: const ScreenTextButtonStyle(
                        text: "Cadastrar Novo Ponto"),
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
