import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat et auth services
  final ChatService _chatServices = ChatService();
  final AuthService _authServices = AuthService();
  // focusNode
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if (!myFocusNode.hasFocus) {
        // délai pour que le clavier se ferme
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // défilement vers le bas
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // envoyer un message
  void sendMessage() async {
    // s'il y'a quelque chose le champ de texte
    if (_messageController.text.isNotEmpty) {
      // envoi du message
      await _chatServices.sendMessage(
          widget.receiverID, _messageController.text);

      // vider le champ de texte
      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          // afficher tous les messages
          Expanded(
            child: _buildMessageList(),
          ),

          //saisie de texte
          _buildUserInput(),
        ],
      ),
    );
  }

  // saisie de texte
  Widget _buildMessageList() {
    String senderID = _authServices.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessages(senderID, widget.receiverID),
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
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // construction de la vue d'un message
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser =
        data["senderID"] == _authServices.getCurrentUser()!.uid;

    // alignement des messages à droite si c'est envoyé par l'utilisateur connecté
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            messageId: doc.id,
            userId: data["senderID"],
          ),
        ],
      ),
    );
  }

  // saisie de texte
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // champ de texte
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Saisissez votre message ...",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // bouton d'envoi
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
