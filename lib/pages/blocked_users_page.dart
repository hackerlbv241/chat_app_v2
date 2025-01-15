import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  // chat et auth services

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  // unblockbox
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Débloquer utilisateur"),
        content: const Text("Vouslez-vous vraiment débloquer cet utilisateur?"),
        actions: [
          //bouton annuler

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),

          // bouton débloquer
          TextButton(
            onPressed: () {
              chatService.unBlockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Utilisateur débloqué")));
            },
            child: const Text("Débloquer"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // obternir les id des utilisateurs
    String userId = authService.getCurrentUser()!.uid;

    //UI
    return Scaffold(
        appBar: AppBar(
          title: const Text("UTILISATEURS BLOQUES"),
          actions: [],
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatService.getBlockedUsersStream(userId),
          builder: (context, snapshot) {
            // erreurs
            if (snapshot.hasError) {
              return const Center(
                child: Text("Erreur de chargement"),
              );
            }

            // chargement en cours
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final blockedUsers = snapshot.data ?? [];

            // pas d'utilisateurs bloqués
            if (blockedUsers.isEmpty) {
              return const Center(
                child: Text("Aucun utilisateur bloqué"),
              );
            }

            // chargement complet
            return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return UserTile(
                  text: user["email"],
                  onTap: () => _showUnblockBox(context, user["iud"]),
                );
              },
            );
          },
        ));
  }
}
