import 'package:chat_app/services/auth/login_or_register.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // si l'utilisateur est connecté, on retourne la page d'accueil
          if (snapshot.hasData) {
            return HomePage();
          }

          // si l'utilisateur n'est pas connecté, on retourne la page de connexion
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
