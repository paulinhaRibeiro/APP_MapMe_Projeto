import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../BD/table_point_interest.dart';
import '../../Models/point_interest.dart';
import '../CRUD_Screens/listagem_point_interesse.dart';

class ListagemPointsRoute extends StatefulWidget {
  final VoidCallback onUpdateListaRoutePoints;
  final int idRoute;
  const ListagemPointsRoute(
      {super.key,
      required this.idRoute,
      required this.onUpdateListaRoutePoints});

  @override
  State<ListagemPointsRoute> createState() => _ListagemPointsRouteState();
}

class _ListagemPointsRouteState extends State<ListagemPointsRoute> {
  var bdPoint = GetIt.I.get<ManipuTablePointInterest>();
  // variavel para capturar todos os pontos de interesse ligados a rota
  late Future<List<PointInterest>> pointRoute;

  @override
  void initState() {
    super.initState();
    // pontos de interesse da rota
    pointRoute = bdPoint.getPointInterestByForeignIdRoute(widget.idRoute);
  }

  // função de callback
  atualizarDadosPoint() {
    setState(() {
      pointRoute = bdPoint.getPointInterestByForeignIdRoute(widget.idRoute);
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
                // Rotas

                // Pontos de interesse
                SingleChildScrollView(
                  child: SizedBox(
                    // altura - pegar 89% da tela disponivel
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * .89,
                    child: Center(
                      child: ListagemPointInteresse(
                        itemsPoint: pointRoute,
                        onUpdateListaPoint: atualizarDadosPoint,
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
}
