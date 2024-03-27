import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';
// tela de atualiza
// import 'package:mapeme/Screens/atualiza_point.dart';
// tela de cadastro
import 'package:mapeme/Screens/CRUD_Screens/cadastro_point.dart';
import 'package:mapeme/Screens/Route/drop_down_choice_route.dart';
import 'package:mapeme/Screens/Route/listagem_route.dart';
// texto do botão
import 'package:mapeme/Screens/Widgets/text_button.dart';
import 'package:mapeme/Screens/CRUD_Screens/details_point.dart';
// widgets especificas da listagem
import '../Widgets/listagem_widgets.dart/circulo_progresso_widget.dart';
import '../Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import '../Widgets/listagem_widgets.dart/imagem_point_widget.dart';
import '../Widgets/listagem_widgets.dart/nome_point_widget.dart';
import '../Widgets/listagem_widgets.dart/turistico_widget.dart';

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
        "Listagem Rotas/Pontos de interesse",
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
                          //
                          child: FutureBuilder<List<PointInterest>>(
                            // cria o obj em cima da variavel items
                            future: items,
                            // para desenhar na tela
                            builder: (context, snapshot) {
                              // se o print que tirar (snapshot) tiver algum dado - desenha a lista
                              if (snapshot.hasData) {
                                List<PointInterest> data = snapshot.data!;

                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    // Card dos elementos do bd
                                    return Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: InkWell(
                                        // Usando InkWell para adicionar interatividade ao Card

                                        onTap: () {
                                          // Ação ao tocar no Card
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsPoint(
                                                onUpdateLista: atualizarDados,
                                                p: data[index],
                                              ),
                                            ),
                                          );
                                        },
                                        borderRadius:
                                            BorderRadius.circular(16.0),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // campo da imagem
                                            data[index].img1 != ""
                                                ? ImagemPoint(
                                                    nomeImagem:
                                                        data[index].img1)
                                                : ImagemPoint(
                                                    nomeImagem:
                                                        data[index].img2),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  NomePoint(
                                                    nomePoint:
                                                        "${data[index].name} - ${data[index].foreignidRoute}",
                                                  ),
                                                  const SizedBox(height: 8),
                                                  // descrição
                                                  DescriptonPoint(
                                                      description: data[index]
                                                          .description),
                                                  const SizedBox(height: 12),
                                                  // Texto de ponto turístico
                                                  NameTypePointInteresse(
                                                    nameTypePoint: data[index]
                                                        .typePointInterest,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  padding: const EdgeInsets.all(10),
                                );
                              } else if (snapshot.hasError) {
                                // se o snapshot possuir um erro
                                Text(
                                    "${snapshot.error}"); //exibi na tela o erro
                              }

                              //caso contrario retorna o circulo de progresso
                              return const Circulo();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      _escolhaRotaPoint();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                      elevation: 10,
                      minimumSize: const Size.fromHeight(55),
                    ),
                    child: const ScreenTextButtonStyle(
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
