import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/Screens/Widgets/text_button.dart';
import 'package:mapeme/Screens/Widgets/text_field_register.dart';

import '../../BD/table_point_interest.dart';

class DropPageChoiceRoute extends StatefulWidget {
  final TabController controllerTab;

  const DropPageChoiceRoute({super.key, required this.controllerTab});

  @override
  State<DropPageChoiceRoute> createState() => _DropPageChoiceRouteState();
}

class _DropPageChoiceRouteState extends State<DropPageChoiceRoute> {
  //para atualizar o estado sem usar o setState
  final dropValue = ValueNotifier("");
  final TextEditingController _typePointController = TextEditingController();

  var bd = GetIt.I.get<ManipuTablePointInterest>();

  // Lista vazia para ser preenchida posteriormente
  List<String> dropOpcoes = [];

  bool _showOutroTextField = false;

  @override
  void initState() {
    super.initState();
    // Carrega os tipos de ponto de interesse ao inicializar o estado
    loadPointInterestTypes();
  }

  void loadPointInterestTypes() async {
    try {
      List<String> types = await bd.getPointInterestTypes();
      setState(() {
        // Limpar a lista atual
        dropOpcoes.clear();
        // Adicionar os tipos recuperados do banco de dados
        dropOpcoes.addAll(types);
        // Adicionar o campo Outro
        dropOpcoes.add("Outro");
      });
    } catch (e) {
      debugPrint("Erro ao carregar tipos de ponto de interesse: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Text(
                "Selecione o item que que melhor se enquadra no seu cadastro",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 93, 93, 93),
                ),
              ),
            ),
            Center(
              child: ValueListenableBuilder(
                valueListenable: dropValue,
                builder: (BuildContext context, String value, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: DropdownButtonFormField<String>(
                      // Define o tamanho do DropdownButtonFormField para preencher o espaço disponível horizontalmente
                      isExpanded: true,
                      // Reduz a altura do DropdownButtonFormField
                      isDense: true,
                      
                      hint: const Text("Escolha o Tipo do Ponto"),
                      decoration: InputDecoration(
                        label: const Text("Tipo"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: (value.isEmpty) ? null : value,
                      onChanged: (escolha) {
                        if (escolha == "Outro") {
                          setState(() {
                            _showOutroTextField = true;
                          });
                        } else {
                          setState(() {
                            _showOutroTextField = false;
                          });
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
                  );
                },
              ),
            ),
            if (_showOutroTextField)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CustomTextField(
                  controller: _typePointController,
                  label: "Digite o Tipo do Ponto *",
                  maxLength: 50,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Campo Obrigatório!";
                    }
                    return null;
                  },
                ),
              ),
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
                      if (_showOutroTextField &&
                          _typePointController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Por favor, digite o tipo do ponto'),
                        ));
                      } else {
                        widget.controllerTab
                            .animateTo(2); // Navegar para a aba "Localização"
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                      elevation: 10,
                    ),
                    child: const ScreenTextButtonStyle(text: "Avançar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _typePointController.dispose();
    super.dispose();
  }
}
