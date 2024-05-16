import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../BD/table_point_interest.dart';
import '../../Models/point_interest.dart';
import '../CRUD_Screens/cadastro_point.dart';
import '../CRUD_Screens/listagem_point_interesse.dart';
import '../Widgets/text_button.dart';
import 'name_id_route.dart';

class ListagemPointsRoute extends StatefulWidget {
  // Lista de imgs dos pontos de interesse da rota
  final VoidCallback onUpdateListaRoutePoints;
  final int idRoute;
  final String nameRoute;
  const ListagemPointsRoute(
      {super.key,
      required this.idRoute,
      required this.onUpdateListaRoutePoints,
      required this.nameRoute});

  @override
  State<ListagemPointsRoute> createState() => _ListagemPointsRouteState();
}

class _ListagemPointsRouteState extends State<ListagemPointsRoute> {
  // Intancia do bd
  var bdPoint = GetIt.I.get<ManipuTablePointInterest>();
  // variavel para capturar todos os pontos de interesse ligados a rota
  late Future<List<PointInterest>> pointRoute;
  // Recebe o nome e o id da rota
  late RouteOption nameIdRoute;

  @override
  void initState() {
    super.initState();
    // Tds os pontos de interesse da rota
    pointRoute = bdPoint.getPointInterestByForeignIdRoute(widget.idRoute);
    // Recebe o nome e o id da rota recebidos via construtor
    nameIdRoute =
        RouteOption(idRoute: widget.idRoute, nameRoute: widget.nameRoute);
  }

  // função de callback
  atualizarDadosPoint() {
    setState(() {
      // Atualiza Tds os pontos de interesse da rota
      pointRoute = bdPoint.getPointInterestByForeignIdRoute(widget.idRoute);
      // Atualiza a lista de imgs da tela de detalhes da Rota
      widget.onUpdateListaRoutePoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Pontos de interesse da Rota",
          textAlign: TextAlign.center,
        ),
      ),
      body: SizedBox(
        // width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height) -
            MediaQuery.of(context).padding.top,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rotas

                // Pontos de interesse
                SingleChildScrollView(
                  child: SizedBox(
                    // altura - pegar 89% da tela disponivel
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Center(
                      // Chama o componente responsavel por listar os pontos de interesse
                      child: ListagemPointInteresse(
                        itemsPoint: pointRoute,
                        // E passa o atualizarDadosPoint para atualizar a listagem dos pontos de interesse da rota
                        onUpdateListaPoint: atualizarDadosPoint,
                      ),
                    ),
                  ),
                ),

                // Cadastrar um novo ponto ligado a esta Rota
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       // Chama a tela de cadastro
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => CadastroPoi(
                //               // Passa o id da Rota para ser add ao atributo do ponto de interesse
                //               idNameRoutePoint: nameIdRoute,
                //             ),
                //           ));
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                //       elevation: 10,
                //       minimumSize: const Size.fromHeight(50),
                //     ),
                //     icon: const Icon(
                //       Icons.add_location_alt_rounded,
                //       color: Colors.white,
                //     ),
                //     label: const ScreenTextButtonStyle(
                //         text: "Cadastrar Novo Ponto"),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 2, 16, 13),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 25,
            offset: const Offset(8, 20),
          ),
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: ElevatedButton.icon(
            onPressed: () {
              // Chama a tela de cadastro
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroPoi(
                      // Passa o id da Rota para ser add ao atributo do ponto de interesse
                      idNameRoutePoint: nameIdRoute,
                    ),
                  ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 63, 6),
              elevation: 10,
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(
              Icons.add_location_alt_rounded,
              color: Colors.white,
            ),
            label: const ScreenTextButtonStyle(text: "Cadastrar Novo Ponto"),
          ),
        ),
      ),
    );
  }
}
