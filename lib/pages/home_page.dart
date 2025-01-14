import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // services de chat et d'authentification
  final ChatService _chatServices = ChatService();
  final AuthService _authServices = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AppChat de PARIS13"),
      ),
      drawer: const MyDrawer(),
      body: _buildUsersList(),
    );
  }

  // construction de la liste des utilisateurs avec tous les users sauf l'utilisateur connecté
  Widget _buildUsersList() {
    return StreamBuilder(
      stream: _chatServices.getUsersStream(),
      builder: (context, snapshot) {
        // erreurs
        if (snapshot.hasError) {
          return const Text("Erreur lors du chargement des utilisateurs");
        }

        // chargement ...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Chargement des utilisateurs ...");
        }

        // retourne la liste des vues
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // construction de la vue d'un utilisateur
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // afficher les utilisateurs sauf l'utilisateur connecté
    if (userData["email"] != _authServices.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
