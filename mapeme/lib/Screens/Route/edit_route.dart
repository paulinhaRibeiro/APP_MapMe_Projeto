import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_route.dart';
import 'package:mapeme/Models/route.dart';

import '../Widgets/text_field_register.dart';

class EditRoute extends StatefulWidget {
  // Função que é executada quando atualiza os dados da rota
  final Function(RoutesPoint) onUpdate;
  // Para quando abrir a tela já ter o obj carregado
  final RoutesPoint route;
  const EditRoute({super.key, required this.onUpdate, required this.route});

  @override
  State<EditRoute> createState() => _EditRouteState();
}

class _EditRouteState extends State<EditRoute> {
  // Obtem a instancia da tabela do bd
  var db = GetIt.I.get<ManipuTableRoute>();
  // variaveis para pegar o q for digitado nas caixinhas de texto
  final nomeUpdateController = TextEditingController();
  final descUpdateController = TextEditingController();
  //para o formulario
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Recebe os valores recebidos via construtor
    nomeUpdateController.text = widget.route.nameRoute;
    descUpdateController.text = widget.route.descriptionRoute;
  }

  _voltarScreen() {
    _aviso("Rota Atualizada com Sucesso");
    Navigator.of(context).pop();
  }

  _aviso(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            msg,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

// Operação de atualização da Rota
  _atualizarRoute() async {
    // Recebe os valores q foram alterados
    var route = RoutesPoint(
      // o Id continua o mesmo
      idRoute: widget.route.idRoute,
      nameRoute: nomeUpdateController.text,
      descriptionRoute: descUpdateController.text,
      imgRoute: "Sem imagem",
    );
    // Chama a função do bd para atualizar a rota
    await db.updateRoute(route);
    // executa a função de atualizar a rota
    widget.onUpdate(route);
    _voltarScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Editar Rota"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: nomeUpdateController,
                    label: "Nome da Rota *",
                    maxLength: 50,
                    validator: (value) =>
                        value!.isEmpty ? "Campo Obrigatório!" : null,
                  ),
                  CustomTextField(
                    controller: descUpdateController,
                    label: "Descrição da Rota",
                    maxLength: 200,
                  ),
                  
                  // 
                  // Botão de Salvar as Alterações
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Chama a função responsavel por atualizar os dados
                                _atualizarRoute();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 63, 6),
                              elevation: 10,
                            ),
                            child: const Text(
                              "Salvar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                // color: Color.fromARGB(255, 0, 63, 6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
