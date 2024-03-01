import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:mapeme/Screens/atualiza_point.dart';
import 'package:mapeme/Screens/cadastro_point.dart';

// // para geolocalizacao
// import 'package:geolocator/geolocator.dart';

class ListagemDados extends StatefulWidget {
  const ListagemDados({super.key});

  @override
  State<ListagemDados> createState() => _ListagemDadosState();
}

class _ListagemDadosState extends State<ListagemDados> {

  var bd = GetIt.I.get<ManipuTablePointInterest>();
  // lista de pontos de interesse
  late Future<List<PointInterest>> items;

  @override
  // metodo disparado quando criar essa tela
  void initState() {
    super.initState();
    items = bd.getPointInterest();
  }

  // sempre que tiver uma modificação, renderiza o componente
  // essa função é executada por callback - vai ser executada em outras classes (arquivos) por callback
  // quando cadastrar chama ela para atualizar a lista
  // executada posteriormente e não quando criada no arquivo original
  atualizarDados() {
    setState(() {
      items = bd.getPointInterest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pontos de interesse"),
      ),
      body: SizedBox(
        // largura total
        width: double.infinity,
        // para não quebrar a tela
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                // altura de 400 onde a lista vai ta sendo exibida
                height: 400,
                width: double.infinity,
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
                          return ListTile(
                            //ou card
                            title: Text(data[index]
                                .name), //passa o nome do elemento da posicao 0, 1, ..., n
                            onTap: () {
                              // passa a funçaõ de callback e o elemento que selecionou
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AtualizarCadastroPoi(
                                            onUpdateList: atualizarDados,
                                            p: data[index],
                                          )));
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      // se o snapshot possuir um erro
                      Text("${snapshot.error}"); //exibi na tela o erro
                    }
                    //caso contrario retorna o circulo de progresso
                    return const Center(
                      child: SizedBox(
                        height:
                            80, // define a altura desejada para o CircularProgressIndicator
                        width:
                            80, // define a largura desejada para o CircularProgressIndicator
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),

              // Botão
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text("add novo point"),
                    onPressed: () {
                      // _localizacaoAtual();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CadastroPoi(onUpdateList: atualizarDados)));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
