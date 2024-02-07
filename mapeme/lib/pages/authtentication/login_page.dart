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
            padding: const EdgeInsets.all(15.0),
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
                    height: 20,
                  ),
                  // --------------- EMAIL -------------
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: TextFormField(
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
                  ),

                  // --------------- SENHA -------------
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: TextFormField(
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
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // --------------- BOTÂO DE LOGIN -------------
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .81,
                    child: ElevatedButton(
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
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text(
                        "ENTRAR",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .85,
                    child: Row(
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
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não Tem cadastro?"),
                      TextButton(
                        onPressed: () {
                          //navegar para a proxima página
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Teste()));
                        },
                        child: const Text("Cadastre-se."),
                      ),
                    ],
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
