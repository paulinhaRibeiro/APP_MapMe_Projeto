import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapeme/Screens/Widgets/text_button.dart';
import '../Widgets/utils/informativo.dart';

class PageSignUp extends StatefulWidget {
  const PageSignUp({super.key});

  @override
  State<PageSignUp> createState() => _PageSignUpState();
}

class _PageSignUpState extends State<PageSignUp> {
  // variaveis do formulario
  final nameControllerSignUp = TextEditingController();
  final emailControllerSignUp = TextEditingController();
  final passwordControllerSignUp = TextEditingController();
  // final confirmPasswordControllerSignUp = TextEditingController();

  // para alterar o estado do icone da senha e repetir senha
  bool isVisibleSignUpSenha = false;
  // bool isVisibleSignUpConfirmSenha = false;

  //para o formulario
  final formKeySignUp = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Cadastro"),),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
              child: Form(
              key: formKeySignUp,
              child: Column(
                children: [
                  // --------------- LOGO -------------
                  Image.asset(
                    "assets/images_logo/logo1.png",
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // --------------- Nome --------------
                  TextFormField(
                    controller: nameControllerSignUp,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo Obrigatório!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text("Nome de Usuário"),
                      prefixIcon: const Icon(
                        Icons.person_rounded,
                      ),
                      // suffixIcon: const Icon(
                      //   FontAwesomeIcons.envelope, //person
                      //   size: 20,
                      // ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // --------------- EMAIL -------------
                  TextFormField(
                    controller: emailControllerSignUp,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo Obrigatório!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text("Email"),
                      prefixIcon: const Icon(
                        Icons.email_rounded,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                  
                    controller: passwordControllerSignUp,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo Obrigatório!";
                      }
                      return null;
                    },
                    //visibilidade da senha
                    obscureText: !isVisibleSignUpSenha,
                    decoration: InputDecoration(
                      label: const Text("Senha"),
                      prefixIcon: const Icon(
                        Icons.key_rounded,
                        // size: 2,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // mudar o icone do botão do icone da senha
                          // para alterar entre visivel e não visivel
                          setState(() {
                            isVisibleSignUpSenha = !isVisibleSignUpSenha;
                          });
                        },
                        icon: Icon(
                          isVisibleSignUpSenha
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          size: 20,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),

                  // const SizedBox(
                  //   height: 20,
                  // ),

                  // // --------------- REPETIR SENHA -------------
                  // TextFormField(
                  //   controller: confirmPasswordControllerSignUp,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Campo Obrigatório!";
                  //     } else if (passwordControllerSignUp.text !=
                  //         confirmPasswordControllerSignUp.text) {
                  //       return "Confirmação de Senha Incorreta";
                  //     }
                  //     return null;
                  //   },
                  //   //visibilidade da senha
                  //   obscureText: !isVisibleSignUpConfirmSenha,
                  //   decoration: InputDecoration(
                  //     label: const Text("Confirmar Senha"),
                  //     suffixIcon: IconButton(
                  //       onPressed: () {
                  //         // mudar o icone do botão do icone da senha
                  //         // para alterar entre visivel e não visivel
                  //         setState(() {
                  //           isVisibleSignUpConfirmSenha =
                  //               !isVisibleSignUpConfirmSenha;
                  //         });
                  //       },
                  //       icon: Icon(
                  //         isVisibleSignUpConfirmSenha
                  //             ? FontAwesomeIcons.eye
                  //             : FontAwesomeIcons.eyeSlash,
                  //         size: 20,
                  //       ),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(
                    height: 25,
                  ),

                  // --------------- BOTÂO DE LOGIN -------------
                  ElevatedButton(
                    onPressed: () {
                      if (formKeySignUp.currentState!.validate()) {
                        Aviso.showSnackBar(
                            context, 'Usuário cadastrado com sucesso');
                        // metodod para o login
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const PageLogin()));
                        Navigator.of(context).pop();
                      }

                      //imprimir os valores no console
                      debugPrint("Email: ${emailControllerSignUp.text}");
                      debugPrint("Senha: ${passwordControllerSignUp.text}");
                      // debugPrint(
                      //     "Repetir Senha: ${confirmPasswordControllerSignUp.text}");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                      elevation: 10,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const ScreenTextButtonStyle(text: "Criar Conta"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // -------- Botão de cadastro fixo na parte inferior da tela ------------------
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        // color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Já tem uma conta?",
              style: TextStyle(fontWeight: FontWeight.w700),
              // style: TextStyle(fontSize: 15),
            ),
            TextButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const PageLogin()),
                // );
                Navigator.of(context).pop();
              },
              child: const Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailControllerSignUp.dispose();
    passwordControllerSignUp.dispose();
    // confirmPasswordControllerSignUp.dispose();
    super.dispose();
  }
}
