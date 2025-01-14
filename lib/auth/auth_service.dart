import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance du service d'authentification
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //se connecter avec son mot de passe et son email
  Future<UserCredential> siignInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // s’inscrire avec email et mot de passe
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
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
