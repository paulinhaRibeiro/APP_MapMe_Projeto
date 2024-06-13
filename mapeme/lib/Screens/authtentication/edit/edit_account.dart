import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapeme/Screens/Widgets/text_button.dart';
import '../../Widgets/drawerUser/user_accout_drawer.dart';
import '../../Widgets/utils/informativo.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  // variaveis do formulario
  final nameControllerUpdate = TextEditingController();
  final emailControllerUpdate = TextEditingController();
  final passwordControllerUpdate = TextEditingController();

  // para alterar o estado do icone da senha e repetir senha
  bool isVisiblePasswordUpdate = false;

  //para o formulario
  final formKeyUpdate = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameControllerUpdate.text = "John Doe";
    emailControllerUpdate.text = "john.doe@example.com";
    passwordControllerUpdate.text = "123456789";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Editar Conta"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // widget personalizada para dados do usuário
            const DrawerUserAccount(),
            //

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: formKeyUpdate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --------------- Nome --------------
                    TextFormField(
                      controller: nameControllerUpdate,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Informa um nome de Usuário!";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text("Nome de Usuário"),
                        prefixIcon: Icon(
                          Icons.person_rounded,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // --------------- EMAIL -------------
                    TextFormField(
                      controller: emailControllerUpdate,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Informe o email corretamente!";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text("Email"),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                        ),
                      ),

                      // Para definir o tipo de teclado para email
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // --------------- SENHA -------------
                    TextFormField(
                      controller: passwordControllerUpdate,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informa sua senha!';
                        } else if (value.length < 6) {
                          return 'Sua senha deve ter no mínimo 6 caracteres';
                        }
                        return null;
                      },
                      //visibilidade da senha
                      obscureText: !isVisiblePasswordUpdate,
                      decoration: InputDecoration(
                        label: const Text("Senha"),
                        prefixIcon: const Icon(
                          Icons.key_rounded,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // mudar o icone do botão do icone da senha
                            // para alterar entre visivel e não visivel
                            setState(() {
                              isVisiblePasswordUpdate =
                                  !isVisiblePasswordUpdate;
                            });
                          },
                          icon: Icon(
                            isVisiblePasswordUpdate
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              elevation: 10,
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKeyUpdate.currentState!.validate()) {
                                Aviso.showSnackBar(
                                    context, 'Dados da Conta Atualizados.');

                                Navigator.of(context).pop();
                              }

                              //imprimir os valores no console
                              debugPrint(
                                  "Email: ${emailControllerUpdate.text}");
                              debugPrint(
                                  "Senha: ${passwordControllerUpdate.text}");
                              // debugPrint(
                              //     "Repetir Senha: ${confirmPasswordControllerSignUp.text}");
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 63, 6),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const ScreenTextButtonStyle(text: "Salvar"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailControllerUpdate.dispose();
    passwordControllerUpdate.dispose();
    // confirmPasswordControllerSignUp.dispose();
    super.dispose();
  }
}
