import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // email et mot de passe controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  LoginPage({super.key});

  // login method
  void login() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo image
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            // message de bienvenue
            Text(
              "Bon retour sur l'AppChat de PARIS13",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16),
            ),

            const SizedBox(height: 25),

            // champ de saisie pour l'email

            MyTextField(
              hintText: "Entrez votre email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            // champ de saisie pour le mot de passe
            MyTextField(
              hintText: "Entrez votre mot de passe",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 25),

            // bouton de connexion

            MyButton(
              text: "Se connecter",
              onTap: login,
            ),

            const SizedBox(height: 25),

            // bouton pour créer un compte

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pas de compte? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                Text(
                  "Inscrivez-vous",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        )));
  }
}
