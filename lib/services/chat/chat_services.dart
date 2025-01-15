import 'package:chat_app/models/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // voir tous les utilisateurs
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()["email"] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });
  }

  // voir les utilisateurs sauf ceux qu'on a bloqué

  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .snapshots()
        .asyncMap((snapshot) async {
      // obtenir les ids des utilisateurs bloqués

      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      // obtenir les utilisateurs (tous)
      final userSnapshot = await _firestore.collection("Users").get();

      // renvoie la liste des utilisateurs sauf ceux qu'on a bloqué et l'utilisateur connecté
      return userSnapshot.docs
          .where((doc) =>
              doc.data()["email"] != currentUser.email &&
              !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // envoi de messages
  Future<void> sendMessage(String receiverID, message) async {
    // obtenir les informations de l'utilisateur connecté
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // creation du nouveau message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp.toString(),
    );

    // construction du chat pour les deux utilisateurs
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // ajout du nouveau messaage à la base de données

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // reception de messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  //  signaler un utilisateur

  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      "reportedBy": currentUser!.uid,
      "messageId": messageId,
      "messageOwnerId": userId,
      "timestamp": FieldValue.serverTimestamp(),
    };

    await _firestore.collection("Reports").add(report);
  }

  //  bloquer un utilisateur
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});
    notifyListeners();
  }

  // débloquer un utilisateur
  Future<void> unBlockUser(String blockUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(blockUserId)
        .delete();
  }

  // voir les utilisateurs bloqués
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection("Users")
        .doc(userId)
        .collection("BlockedUsers")
        .snapshots()
        .asyncMap((snapshot) async {
      // obtenir les ids des utilisateurs bloqués
      final BlockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        BlockedUserIds.map(
            (id) => _firestore.collection("Users").doc(id).get()),
      );
      // retourne une liste des utilisateurs bloqués
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
