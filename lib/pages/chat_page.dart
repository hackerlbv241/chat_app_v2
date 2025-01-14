import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat et auth services
  final ChatService _chatServices = ChatService();
  final AuthService _authServices = AuthService();

  // envoyer un message
  void sendMessage() async {
    // s'il y'a quelque chose le champ de texte
    if (_messageController.text.isNotEmpty) {
      // envoi du message
      await _chatServices.sendMessage(receiverID, _messageController.text);

      // vider le champ de texte
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(
        children: [
          // afficher tous les messages
          Expanded(
            child: _buildMessageList(),
          ),

          //saisie de texte
          _buildMessageInput(),
        ],
      ),
    );
  }

  // saisie de texte
  Widget _buildMessageList() {
    String senderID = _authServices.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        // erreurs
        if (snapshot.hasError) {
          return const Text("Erreur lors du chargement des messages");
        }

        // chargement ...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Chargement des messages ...");
        }

        // retourne la liste des vues
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // construction de la vue d'un message
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Text(data["message"]);
  }

  // saisie de texte
  Widget _buildMessageInput() {
    return Row(
      children: [
        // champ de texte
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: "Saisissez votre message ...",
            obscureText: false,
          ),
        ),

        // bouton d'envoi
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_upward),
        ),
      ],
    );
  }
}
