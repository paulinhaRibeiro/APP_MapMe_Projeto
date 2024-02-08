import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapeme/pagTeste.dart';


class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  // variaveis do formulario
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // para alterar o estado do icone da senha
  bool isVisible = false;

  //para o formulario
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // --------------- LOGO -------------
                  Image.asset(
                    "assets/images_logo/logo1.png",
                    width: 230,
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                  // --------------- EMAIL -------------
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo Obrigatório!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text("Email"),
                      suffixIcon: const Icon(
                        FontAwesomeIcons.envelope, //person
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // --------------- SENHA -------------
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo Obrigatório!";
                      }
                      return null;
                    },
                    //visibilidade da senha
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      label: const Text("Senha"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // mudar o icone do botão do icone da senha
                          // para alterar entre visivel e não visivel
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(
                          isVisible
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          size: 20,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // --------------- BOTÂO DE LOGIN -------------
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // metodod para o login
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Teste()));
                      }
                      debugPrint("Email: ${emailController.text}");
                      debugPrint("Senha: ${passwordController.text}");
                    },
                    style: ElevatedButton.styleFrom(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),),
                      elevation: 10,
                      minimumSize: const Size.fromHeight(55),
                    ),
                    child: const Text(
                      "Entrar",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  // --------------- Botão de esqueceu a senha -----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Teste()));
                        },
                        child: const Text("Esqueceu a senha?"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ------------------- Botão de cadastro fixo na parte inferior da tela ------------------
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        // color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Não tem uma conta?",
              // style: TextStyle(fontSize: 15),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Teste()),//PageSignUp()),
                );
              },
              child: const Text("Cadastre-se."),
            ),
          ],
        ),
      ),
    );
  }
}
