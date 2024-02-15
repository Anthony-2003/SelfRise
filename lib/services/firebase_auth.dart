import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServ {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> SignUpPassAndEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print('Ha ocurrido un error');
    }
    return null;
  }
    Future<User?> SignInPassAndEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print('Ha ocurrido un error');
    }
    return null;
  }
}
