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

// Tela responsavel por listar todas as rotas e pontos de interesse cadastrados
class ListagemDados extends StatefulWidget {
  const ListagemDados({super.key});

  @override
  State<ListagemDados> createState() => _ListagemDadosState();
}

class _ListagemDadosState extends State<ListagemDados>
    with SingleTickerProviderStateMixin {
  //
  // Pontos de interess
  // referencia da tabela que manipula os pontos de interesse
  var bd = GetIt.I.get<ManipuTablePointInterest>();
  // lista de pontos de interesse
  late Future<List<PointInterest>> items;

  // Rota
  var bdRoute = GetIt.I.get<ManipuTableRoute>();
  // lista de rotas
  late Future<List<RoutesPoint>> itemsRoute;

  // Para controlar o TabBar
  late TabController _tabListagemController;

  // TextEditingController para  o campo de pesquisa
  final TextEditingController searchController = TextEditingController();

  // metodo disparado quando criar essa tela
  @override
  void initState() {
    super.initState();
    _tabListagemController = TabController(length: 2, vsync: this);
    // Pontos de interesse
    // o Items recebe todos os pontos de interesse cadastrados
    items = bd.getPointInterest();
    // Rota
    // o itemsRoute recebe todas as rotas cadastrados
    itemsRoute = bdRoute.getRoute();
  }

  // sempre que tiver uma modificação, renderiza o componente
  // essa função é executada por callback - vai ser executada em outras classes (arquivos) por callback
  // quando cadastrar chama ela para atualizar a lista
  // executada posteriormente e não quando criada no arquivo original
  atualizarDados() {
    setState(() {
      // Atualiza os dados da rota e pontos de interesse
      items = bd.getPointInterest();
      itemsRoute = bdRoute.getRoute();
    });
  }

  //
  // Função para escolher se faz parte de uma rota ou não
  Future<void> _escolhaRotaPoint() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Faz parte de uma Rota?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: <Widget>[
            // Se não fizer parte de uma rota vai para a tela de cadastrar um ponto de
            //interesse que é algum ponto turistico por exemplo: sem tá ligado a uma rota
            TextButton(
              onPressed: () {
                // Fechar e navegar para a proxima pagina
                Navigator.of(context).pop(true);
                // Vai para a tela de cadastrar o ponto sem ser ligado a nenhuma rota
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroPoi(
                      // Só passa a função de callback para atualizar os elementos quando cadastrar
                      onUpdateList: atualizarDados,
                    ),
                  ),
                );
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
                // quando faz parte de uma rota, fecha o AlertDialog
                Navigator.of(context).pop(true);
                // e vai para a tela de escolher ou criar uma nova rota
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
      title: Image.asset(
        "assets/images_logo/MapME.png",
        height: MediaQuery.of(context).size.height * 0.07, //7% da altura total da tela
      ), //Text('MapMe'),

      bottom: TabBar(
        controller: _tabListagemController,
        tabs: const [
          Tab(
            icon: Icon(Icons.alt_route_rounded),
            text: 'Rotas',
          ),
          Tab(
            icon: Icon(Icons.share_location_rounded),
            text: 'Pontos de Interesse',
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Column(
            children: [
              // Botão de buscar
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 16, 25, 1),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 63, 6),
                      // width: 2.5,
                    ),
                  ),

                  // Buscar por Nome
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            labelText: 'Buscar',
                            hintText: "Buscar pelo nome",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        // color: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 63, 6),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 63, 6)
                                  .withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.manage_search_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            // Se tiver no TabBar zero - Rota
                            if (_tabListagemController.index == 0) {
                              // Rota
                              setState(() {
                                // Atualiza a rota de acordo com o valor digitado e filtra e ordena pelo nome do ponto de interesse
                                itemsRoute = bdRoute
                                    .getSearchNameRoute(searchController.text);
                              });
                            } else {
                              // Se tiver no TabBar um - Ponto de interesse
                              // ponto de interesse
                              setState(() {
                                // Atualiza o ponto de interesse de acordo com o valor digitado e filtra e ordena pelo nome da rota
                                items = bd
                                    .getSearchNamePoint(searchController.text);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // End Botão de buscar

              Expanded(
                child: TabBarView(
                  controller: _tabListagemController,
                  children: [
                    //

                    // TabBar 1
                    // Cards da Rotas
                    SingleChildScrollView(
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * .82, //.75,
                        child: Center(
                          // Chama a função de listar todas as Rotas
                          child: ListagemRoute(
                            // Todas as Rotas
                            itemsRoute: itemsRoute,
                            // Função de Callback para ser executada posteriormente
                            onUpdateListaRoute: atualizarDados,
                          ),
                        ),
                      ),
                    ),

                    // TabBar 1
                    // Cards do Pontos de interesse
                    SingleChildScrollView(
                      child: SizedBox(
                        // altura - pegar 89% da tela disponivel
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * .82, //75, //89
                        child: Center(
                          // Chama a função de listar todos pontos de interesse
                          child: ListagemPointInteresse(
                            // Passa todos os pontos de interesse
                            itemsPoint: items,
                            // Função de Callback para ser executada posteriormente
                            onUpdateListaPoint: atualizarDados,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //
              //Botão para cadastrar um novo ponto
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Ao clicar chama a função _escolhaRotaPoint
                    _escolhaRotaPoint();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                    elevation: 10,
                    minimumSize: const Size.fromHeight(55),
                  ),
                  icon: const Icon(
                    Icons.add_location_alt_rounded,
                    color: Colors.white,
                  ),
                  label:
                      const ScreenTextButtonStyle(text: "Cadastrar Novo Ponto"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
