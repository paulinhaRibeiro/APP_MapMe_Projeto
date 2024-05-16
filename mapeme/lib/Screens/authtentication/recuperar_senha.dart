import 'package:flutter/material.dart';
import 'package:mapeme/Screens/Widgets/listagem_widgets.dart/descricao_point_widget.dart';
import 'package:mapeme/Screens/Widgets/text_button.dart';

import '../Widgets/listagem_widgets.dart/nome_point_widget.dart';

class Teste extends StatelessWidget {
  const Teste({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.mail_lock_rounded,
                    size: 45,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const NomePoint(nomePoint: "Recuperar Senha"),
              const SizedBox(
                height: 15,
              ),
              const DescriptonPoint(
                description:
                    "Por favor, Informe o endereço de email associado a sua conta para que possamos enviar um link de redefinição.",
                numLines: 50,
                textAlign: true,
              ),
              const SizedBox(
                height: 20,
              ),
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
                height: 25,
              ),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 63, 6),
                  elevation: 10,
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(
                  Icons.email_rounded,
                  color: Colors.white,
                ),
                label: const ScreenTextButtonStyle(text: "Enviar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
