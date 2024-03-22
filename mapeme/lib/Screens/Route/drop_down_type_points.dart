import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_route.dart';
import 'package:mapeme/Screens/Widgets/text_button.dart';
// import 'package:mapeme/Screens/Widgets/text_field_register.dart';

// import '../../Models/route.dart';

class DropPageChoiceRoute extends StatefulWidget {
  const DropPageChoiceRoute({super.key});

  @override
  State<DropPageChoiceRoute> createState() => _DropPageChoiceRouteState();
}

class _DropPageChoiceRouteState extends State<DropPageChoiceRoute> {
  //para atualizar o estado sem usar o setState
  final dropValue = ValueNotifier("");
  // final TextEditingController _newRouteController = TextEditingController();

  var bd = GetIt.I.get<ManipuTableRoute>();

  // Lista vazia para ser preenchida posteriormente
  List<String> dropOpcoes = [];

  bool showOutroTextField = false;
  // late Future<List<RoutesPoint>> items;

  final textButton = ValueNotifier("Avançar"); //"Avançar";

  @override
  void initState() {
    super.initState();
    // Todos os itens da rota
    // items = bd.getRoute();
    // Carrega os tipos de ponto de interesse ao inicializar o estado
    loadRoute();
  }

  void loadRoute() async {
    try {
      //
      List<String> nameRoutes = await bd.getNameRoutes();
      setState(() {
        // Limpar a lista atual
        dropOpcoes.clear();
        // Adicionar os tipos recuperados do banco de dados
        dropOpcoes.addAll(nameRoutes);
        // Adicionar o campo Outro
        dropOpcoes.add("Nova Rota");
      });
    } catch (e) {
      debugPrint("Erro ao carregar o Nome da Rota: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ValueListenableBuilder(
                  valueListenable: dropValue,
                  builder: (BuildContext context, String value, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            // Define o tamanho do DropdownButtonFormField para preencher o espaço disponível horizontalmente
                            isExpanded: true,
                            // Reduz a altura do DropdownButtonFormField
                            isDense: true,

                            hint: const Text("Escolha a Rota *"),
                            decoration: InputDecoration(
                              // helperText:
                              //     'Caso a Rota mais condizente com o seu cadastro não estiver na lista, selecione "Nova Rota" e insira manualmente no campo de texto.',
                              // helperMaxLines: 5,
                              label: const Text("Rota *"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: (value.isEmpty) ? null : value,
                            onChanged: (escolha) {
                              if (escolha == "Nova Rota") {
                                textButton.value = "Cadastrar Nova Rota";
                                // setState(() {
                                //   _showOutroTextField = true;
                                //   textButton = "Cadastrar Nova Rota";
                                // });
                              } else {
                                textButton.value = "Avançar";
                                // setState(() {
                                //   _showOutroTextField = false;
                                //   textButton = "Avançar";
                                // });
                              }
                              dropValue.value = escolha.toString();
                            },
                            items: dropOpcoes
                                .map(
                                  (op) => DropdownMenuItem(
                                    value: op,
                                    child: Text(op),
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
              // if (_showOutroTextField)
              //   // quando entrar aqui vai chamar outra classe para criar a rota
              //   Padding(
              //     padding: const EdgeInsets.only(top: 10),
              //     child: CustomTextField(
              //       controller: _newRouteController,
              //       label: "Digite o nome da Rota *",
              //       maxLength: 50,
              //       validator: (value) {
              //         if (value!.isEmpty) {
              //           return "Campo Obrigatório!";
              //         }
              //         return null;
              //       },
              //     ),
              //   ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (showOutroTextField){
                          
                          
                          // Tela de Cadastrar Rota
                        }
                        else{
                          // Rota existente -> passar ID só e cadastrar o ponto
                        }


                        // if (_showOutroTextField &&
                        //     _newRouteController.text.isEmpty) {
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(const SnackBar(
                        //     content: Text('Por favor, digite o nome da Rota'),
                        //   ));
                        // } else {
                        //   // widget.controllerTab
                        //   //     .animateTo(2); // Navegar para a aba "Localização"
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                        elevation: 10,
                      ),
                      child: ScreenTextButtonStyle(text: textButton.value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    
    super.dispose();
  }
}
