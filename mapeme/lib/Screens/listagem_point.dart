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
    var appBar = AppBar(
      // retirar o icone da seta que é gerado automaticamente
      automaticallyImplyLeading: false,
      // icone de Seta para voltar
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back), // Ícone de seta de volta
      //   onPressed: () {
      //     // Ação ao pressionar o botão de volta
      //     Navigator.pop(context); // Volta para a tela anterior
      //   },
      // ),
      //

      title: const Text(
        "Pontos de interesse",
        textAlign: TextAlign.center,
      ),

      // icone de pesquisa
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        )
      ],
      //
    );

    // Variaveis para regular os componentes de acordo com o tamanho da tela
    var size = MediaQuery.of(context).size;
    var screenHeight = (size.height - appBar.preferredSize.height) -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        // largura total
        width: size.width,
        height: size.height,
        // para não quebrar a tela
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                // altura de 400 onde a lista vai ta sendo exibida
                height: screenHeight * .89,
                width: size.width,
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
                          return Card(
                            // color: const Color.fromARGB(255, 255, 255, 255),
                            // shadowColor: const Color.fromARGB(255, 255, 255, 255),
                            surfaceTintColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            elevation:
                                5, // Adicionando uma elevação para dar uma sombra ao Card
                            child: InkWell(
                              // Usando InkWell para adicionar interatividade ao Card
                              onTap: () {
                                // Ação ao tocar no Card
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AtualizarCadastroPoi(
                                      onUpdateList: atualizarDados,
                                      p: data[index],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Texto do nome centralizado
                                    Text(
                                      data[index].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 63, 6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Espaçamento entre os elementos

                                    index.isEven
                                        ? Row(
                                            // Para índices pares, imagem à esquerda e descrição à direita
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,

                                            children: <Widget>[
                                              Expanded(
                                                flex:
                                                    2, // Define a largura da imagem
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Define as bordas arredondadas
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(
                                                                0.5), // Cor da sombra
                                                        spreadRadius:
                                                            2, // Espalhamento da sombra
                                                        blurRadius:
                                                            5, // Raio de desfoque da sombra
                                                        offset: const Offset(0,
                                                            3), // Deslocamento da sombra em x e y
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Adiciona bordas arredondadas à imagem
                                                    child: Image.asset(
                                                      "assets/images_geral/gritador_teste.png",
                                                      // width: 100,
                                                      // height: 100,
                                                      fit: BoxFit
                                                          .cover, // Ajusta o tamanho da imagem
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      8), // Espaçamento entre a imagem e a descrição
                                              Expanded(
                                                flex:
                                                    3, // Define a largura da descrição
                                                child: Text(
                                                  data[index].description,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            // Para índices pares, imagem à esquerda e descrição à direita
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,

                                            children: <Widget>[
                                              // Espaçamento entre a imagem e a descrição
                                              Expanded(
                                                flex:
                                                    3, // Define a largura da descrição
                                                child: Text(
                                                  data[index].description,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                flex:
                                                    2, // Define a largura da imagem
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Define as bordas arredondadas
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(
                                                                0.5), // Cor da sombra
                                                        spreadRadius:
                                                            2, // Espalhamento da sombra
                                                        blurRadius:
                                                            5, // Raio de desfoque da sombra
                                                        offset: const Offset(0,
                                                            3), // Deslocamento da sombra em x e y
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Adiciona bordas arredondadas à imagem
                                                    child: Image.asset(
                                                      "assets/images_geral/gritador_teste.png",
                                                      // width: 100,
                                                      // height: 100,
                                                      fit: BoxFit
                                                          .cover, // Ajusta o tamanho da imagem
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(
                                        height:
                                            8), // Espaçamento entre os elementos

                                    // Texto de ponto turístico centralizado
                                    Text(
                                      data[index].turisticPoint == 1
                                          ? "Ponto Turístico"
                                          : "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          // fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 93, 9)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(10),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                child: ElevatedButton(
                  onPressed: () {
                    // _localizacaoAtual();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CadastroPoi(onUpdateList: atualizarDados)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10),),
                    elevation: 10,
                    minimumSize: const Size.fromHeight(55),
                  ),
                  child: const Text(
                    "Cadastrar Nova Rota",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      // color: Color.fromARGB(255, 0, 63, 6),
                    ),
                  ),
                ),
              ),

              // // // Botão
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 8, vertical: 16),

              //   child: SizedBox(
              //     height: 40,
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         // shape: RoundedRectangleBorder(
              //         //   borderRadius: BorderRadius.circular(10),),
              //         elevation: 10,
              //         minimumSize: const Size.fromHeight(55),
              //       ),
              //       child: const Text("add novo point"),
              //       onPressed: () {
              //         // _localizacaoAtual();
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) =>
              //                     CadastroPoi(onUpdateList: atualizarDados)));
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   width: double.infinity,
      //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      //   // color: const Color.fromARGB(255, 255, 255, 255),
      //   child: SizedBox(
      //     height: 40,
      //     width: double.infinity,
      //     child: ElevatedButton(
      //       child: const Text("add novo point"),
      //       onPressed: () {
      //         // _localizacaoAtual();
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) =>
      //                     CadastroPoi(onUpdateList: atualizarDados)));
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}
