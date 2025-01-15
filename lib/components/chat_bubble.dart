import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });

  // montrer les options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            // message du bouton de signalement
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text("Signaler"),
              onTap: () {
                Navigator.pop(context);
                _reportMessage(context, messageId, userId);
              },
            ),

            // bloquer l'utilisateur bouton
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text("Bloquer"),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userId);
              },
            ),

            // cancel bouton
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Annuler"),
              onTap: () => Navigator.pop(context),
            )
          ],
        ));
      },
    );
  }

  // signaler un message
  void _reportMessage(BuildContext context, String messageId, String userId) {
    // code pour signaler un message
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Signaler ce message"),
              content: const Text("Voulez-vous vraiment signaler ce message?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),

                // signaler bouton
                TextButton(
                  onPressed: () {
                    ChatService().reportUser(messageId, userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Message signalé")));
                  },
                  child: const Text("Signaler"),
                ),
              ],
            ));
  }

  // bloquer l'utilisateur
  void _blockUser(BuildContext context, String userId) {
    // code pour signaler un utilisateur
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Bloquer cet utilisateur"),
              content:
                  const Text("Voulez-vous vraiment bloquer cet utilisateur?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),

                // bloquer bouton
                TextButton(
                  onPressed: () {
                    ChatService().blockUser(userId);
                    Navigator.pop(context);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Utilisateur bloqué")));
                  },
                  child: const Text("Bloquer"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //light vs dark mode pour la couleur correcte de la bulle de chat
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // montrer les options
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
        child: Text(
          message,
          style: TextStyle(
              color: isCurrentUser
                  ? Colors.white
                  : isDarkMode
                      ? Colors.white
                      : Colors.black),
        ),
      ),
    );
  }
}
