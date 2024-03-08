import 'package:flutter/material.dart';

// para geolocalizacao
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Models/point_interest.dart';

//
import 'package:mapeme/Localization/geolocalization.dart';

//
class CadastroPoi extends StatefulWidget {
  const CadastroPoi({super.key, required this.onUpdateList});
  // recebe a função de atualizar a lista da classe de listagem
  final VoidCallback onUpdateList;

  @override
  State<CadastroPoi> createState() => _CadastroPoiState();
}

class _CadastroPoiState extends State<CadastroPoi>
    with SingleTickerProviderStateMixin {
  // para controlar o TabBar
  late TabController _tabController;
  // variaveis para pegar o q for digitado nas caixinhas de texto
  final nome = TextEditingController();
  final desc = TextEditingController();
  final latitude = TextEditingController();
  final longitude = TextEditingController();
  final img1 = TextEditingController();
  final img2 = TextEditingController();
  // final pontoTuristico = TextEditingController();

  // Para controlar o evento do clique do usuario
  bool clickPontoTuristico = false;
  final sicronizado = TextEditingController();
  //

  // Obtem a instancia da tabela do bd
  var db = GetIt.I.get<ManipuTablePointInterest>();

  //
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initLocation();
  }

  void _initLocation() async {
    // Inicializa os controladores com "Carregando..."
    latitude.text = "Carregando...";
    longitude.text = "Carregando...";

    // Obtém a localização atual ao iniciar a tela
    Position? position = await obterLocalizacaoAtual();

    if (position != null && mounted) {
      setState(() {
        latitude.text = position.latitude.toString();
        longitude.text = position.longitude.toString();
      });
    } else {
      debugPrint("position é null $errorLocation");
    }
  }

  // Fecha a tela
  _voltarScreen() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastrado com sucesso')),
    );
    Navigator.of(context).pop();
  }

  // Operação de cadastrar BD
  _cadastrarPoi() async {
    // Operação assincrona
    // Cria um novo obj PointInterest
    var p = PointInterest(
      id: 0, // para q o sqlite gerencie o id
      name: nome.text,
      description: desc.text,
      latitude: double.parse(latitude.text),
      longitude: double.parse(longitude.text),
      img1: img1.text,
      img2: img2.text,
      // turisticPoint: int.parse(pontoTuristico.text),
      turisticPoint: clickPontoTuristico ? 1 : 0,

      // é zero pq sempre quando cadastrar via verificar se possui conexão com a internet, se tiver, vai mandar para o bd remoto e marcar com 1 (sincronizado)
      synced: 0, //int.parse(sicronizado.text),
    );

    await db.insertPointInterest(p); // converte para toMap e grava no sqlite
    // acessa a função de callback - executa a funcao do outro arquivo - Atualiza a lista de pontos de interesse
    widget.onUpdateList();

    // Fecha a tela
    // Navigator.of(context).pop();
    _voltarScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Cadastro de Rota/POI"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.info),
              text: 'Sobre a Rota',
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
          // Primeira Aba -> a de Sobre a Rota
          SingleChildScrollView(
            child: SizedBox(
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text("Nome"),
                        ),
                        // controlada pela variavel nome
                        controller: nome,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text("Descrição"),
                        ),
                        controller: desc,
                      ),
                    ),

                    //
                    // img1
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text("informe a img1"),
                        ),
                        controller: img1,
                      ),
                    ),

                    //
                    // img2
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text("informe a img2"),
                        ),
                        controller: img2,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 150,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 63, 6),
                              border: Border.all(
                                color: const Color.fromARGB(
                                    255, 0, 49, 5), // Cor da borda
                                // width: 2, // Largura da borda
                              ),

                              borderRadius:
                                  BorderRadius.circular(50), // Raio da borda
                            ),
                            child: TextButton(
                              onPressed: () {
                                _tabController.animateTo(
                                    1); // Navegar para a aba "Localização"
                              },
                              child: const Text(
                                "Avançar",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

//

          // Segunda Aba -> a de Localização
          SingleChildScrollView(
            child: SizedBox(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    // latitude
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: TextField(
                        readOnly: true,
                        // enabled: false, // para evitar a edição
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text("Longitude"),
                        ),
                        controller: latitude,
                      ),
                    ),

                    // Longitude
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: TextField(
                        readOnly: true,
                        // enabled: false, // para evitar a edição
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text("Latitude"),
                        ),
                        controller: longitude,
                      ),
                    ),

                    // se é rota ou ponto turistico
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                              value: clickPontoTuristico,
                              onChanged: (value) {
                                setState(() {
                                  clickPontoTuristico = value!;
                                });
                              }),
                          const Text("É Ponto Turistico")
                        ],
                      ),
                    ),

                    // Botão para cadastrar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          _cadastrarPoi();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                          elevation: 10,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          "Salvar",
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
