import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';
// tela de atualiza
import 'package:mapeme/Screens/atualiza_point.dart';
// tela de cadastro
import 'package:mapeme/Screens/cadastro_point.dart';
// texto do botão
import 'package:mapeme/Screens/Widgets/text_button.dart';
// widgets especificos da listagem
import 'Widgets/listagem_widgets.dart/circulo_progresso_widget.dart';
import 'Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import 'Widgets/listagem_widgets.dart/imagem_point_widget.dart';
import 'Widgets/listagem_widgets.dart/nome_point_widget.dart';
import 'Widgets/listagem_widgets.dart/turistico_widget.dart';

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
      centerTitle: true,
      title: const Text(
        "Pontos de interesse",
        textAlign: TextAlign.center,
      ),

      // icone de pesquisa
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          // quando clicar e segurar aparecer o nome buscar
          tooltip: 'Buscar',
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
                // altura - pegar 89% da tela disponivel
                height: screenHeight * .89,
                width: size.width,
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
                          return Card(
                            surfaceTintColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            // Adicionando uma elevação para dar uma sombra ao Card
                            elevation: 5,
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

                              // nome do ponto
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Texto do nome centralizado
                                    NomePoint(
                                      nomePoint: data[index].name,
                                    ),

                                    // Espaçamento entre os elementos
                                    const SizedBox(height: 8),

                                    // Para índices pares, imagem à esquerda e descrição à direita
                                    index.isEven
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              // campo da imagem

                                              data[index].img1 != ""
                                                  ? ImagemPoint(
                                                      nomeImagem:
                                                          data[index].img1)
                                                  : ImagemPoint(
                                                      nomeImagem:
                                                          data[index].img2),
                                              // const ImagemPoint(
                                              //     nomeImagem:
                                              //         "assets/images_geral/gritador_teste.png"),

                                              // Espaçamento entre a imagem e a descrição
                                              const SizedBox(width: 8),

                                              // descrição
                                              DescriptonPoint(
                                                  description:
                                                      data[index].description),
                                            ],
                                          )
                                        : Row(
                                            // Para índices pares, imagem à esquerda e descrição à direita
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,

                                            children: <Widget>[
                                              //
                                              // descrição
                                              DescriptonPoint(
                                                  description:
                                                      data[index].description),

                                              // Espaçamento entre a imagem e a descrição
                                              const SizedBox(width: 8),

                                              // campo da imagem
                                              ImagemPoint(
                                                  nomeImagem: data[index].img1),
                                            ],
                                          ),
                                    // Espaçamento entre os elementos
                                    const SizedBox(height: 8),

                                    // Texto de ponto turístico centralizado
                                    TuristicPoint(
                                      pontoTuristico: data[index].turisticPoint,
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
                    return const Circulo();
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CadastroPoi(onUpdateList: atualizarDados)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                    elevation: 10,
                    minimumSize: const Size.fromHeight(55),
                  ),
                  child:
                      const ScreenTextButtonStyle(text: "Cadastrar Nova Rota"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
