import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapeme/Screens/Widgets/text_button.dart';

// arquivos
// import 'package:mapeme/Screens/authtentication/signup_page.dart';
import 'package:mapeme/Screens/CRUD_Screens/tab_listagens.dart';
import 'package:mapeme/Screens/authtentication/recuperar_senha.dart';

import '../Widgets/divide_text.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  // variaveis do formulario
  final nameControllerSignUp = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // para alterar o estado do icone da senha
  bool isVisible = false;

  //para o formulario
  final formKey = GlobalKey<FormState>();

  bool isLogin = true;
  // nome do botão
  late String actionButton;
  // texto junto do botão
  late String textButton;
  // texto do botao
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // Mudar de login para registro
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      debugPrint(isLogin.toString());
      if (isLogin) {
        actionButton = 'Entrar';
        textButton = "Ainda não tem conta?";
        toggleButton = 'Cadastre-se.';
      } else {
        actionButton = 'Criar Conta';
        textButton = "Já tem uma conta?";
        toggleButton = 'Voltar ao Login.';
      }
    });
  }

  // login() async {
  //   setState(() => loading = true);
  //   try {
  //     await context.read<AuthService>().login(email.text, senha.text);
  //   } on AuthException catch (e) {
  //     setState(() => loading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
  //   }
  // }

  // registrar() async {
  //   setState(() => loading = true);
  //   try {
  //     await context.read<AuthService>().registrar(email.text, senha.text);
  //   } on AuthException catch (e) {
  //     setState(() => loading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
  //   }
  // }

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
                    height: MediaQuery.of(context).size.height *
                        0.17, //17% da altura total da tela //height: 130,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  if (!isLogin)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: TextFormField(
                        controller: nameControllerSignUp,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Informa um nome de Usuário!";
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
                    ),

                  // --------------- EMAIL -------------
                  TextFormField(
                    controller: emailController,

                    // validar o que foi passado no formulario
                    validator: (value) {
                      // se o campo for vazio
                      if (value!.isEmpty) {
                        return "Informe o email corretamente!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',

                      prefixIcon: const Icon(
                        Icons.email_rounded,
                        // size: 20,
                      ),
                      // suffixIcon: const Icon(
                      //   FontAwesomeIcons.envelope, //person
                      //   size: 20,
                      // ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // borderSide: BorderSide.none,
                      ),
                    ),

                    // Para definir o tipo de teclado para email
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // --------------- END EMAIL -------------

                  const SizedBox(
                    height: 15,
                  ),

                  // --------------- SENHA -------------
                  TextFormField(
                    controller: passwordController,

                    // validar o que foi passado no formulario
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informa sua senha!';
                      } else if (value.length < 6) {
                        return 'Sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                    //visibilidade da senha
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(
                        Icons.key_rounded,
                        // size: 2,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // mudar o estado do icone do botão de senha
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
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),

                  // --------------- Botão de esqueceu a senha -----------------
                  if (isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Teste()));
                        },
                        child: const Text(
                          "Esqueceu a senha?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  SizedBox(
                    height: (isLogin) ? 10 : 25,
                  ),

                  // --------------- BOTÂO DE LOGIN -------------
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // if (isLogin) {
                        //   login();
                        // } else {
                        //   registrar();
                        // }
                        // Se os dados passado no formulario de login forem validos chama a tela "ListagemDados"
                        // Navega para a segunda tela e remove todas as telas na pilha
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListagemDados(),
                          ),
                          (route) => false,
                        );
                      }
                      debugPrint("Email: ${emailController.text}");
                      debugPrint("Senha: ${passwordController.text}");
                    },
                    style: ElevatedButton.styleFrom(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),),
                      backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                      elevation: 10,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: ScreenTextButtonStyle(text: actionButton),
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  const DividerText(
                    text: 'Ou',
                    // textAlign: TextAlign.center,
                    // style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      elevation: 10,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(FontAwesomeIcons.google),
                    label: const Text("Entrar com Google"),
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
            Text(
              textButton,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextButton(
              // onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => const PageSignUp()),
              //   );
              // },
              onPressed: () => setFormAction(!isLogin),
              child: Text(
                toggleButton,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
