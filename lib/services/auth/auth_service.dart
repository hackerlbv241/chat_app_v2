import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance du service d'authentification et firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // avoir l'utilisateur connecté
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //se connecter avec son mot de passe et son email
  Future<UserCredential> siignInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // sauvegarde de l'utilisateur s'il n'existe pas
      _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          'iud': userCredential.user!.uid,
          'email': email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // s’inscrire avec email et mot de passe
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      // création de l'utilisateur
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // sauvegarde de l'utilisateur dans un fichier séparé
      _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          'iud': userCredential.user!.uid,
          'email': email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // se déconnecter
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // éventuelles erreurs
}
