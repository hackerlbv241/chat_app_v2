import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            ),

            const SizedBox(height: 10),

            // champ de saisie pour le mot de passe
            MyTextField(
              hintText: "Entrez votre mot de passe",
              obscureText: true,
            ),

            // bouton de connexion

            // bouton pour créer un compte
          ],
        )));
  }
}
