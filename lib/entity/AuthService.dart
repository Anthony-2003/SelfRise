import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Método para iniciar sesión con Google
  static Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
      final User? user = authResult.user;

      // Guardar los datos del usuario en Firestore
      if (user != null) {
        await _saveUserData(user.uid, {
          'name': user.displayName,
          'email': user.email,
          'img': user.photoURL,
          'id': user.uid,
        });
      }
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
    }
  }
  
  static Future<void> _saveUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('user').doc(userId).set(userData);
    } catch (error) {
      print('Error al guardar los datos del usuario: $error');
    }
  }

  static Future<String?> getUserName() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDataSnapshot = await _firestore.collection('user').doc(user.uid).get();
        return userDataSnapshot.get('name');
      }
      return null;
    } catch (error) {
      print('Error al obtener el nombre del usuario: $error');
      return null;
    }
  }

  static Future<String?> getUserPhotoUrl() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDataSnapshot = await _firestore.collection('user').doc(user.uid).get();
        return userDataSnapshot.get('img');
      }
      return null;
    } catch (error) {
      print('Error al obtener la foto de perfil del usuario: $error');
      return null;
    }
  }

  static Future<String?> getUserEmail() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDataSnapshot = await _firestore.collection('user').doc(user.uid).get();
        return userDataSnapshot.get('email');
      }
      return null;
    } catch (error) {
      print('Error al obtener el email del usuario: $error');
      return null;
    }
  }

  static String? getUserId() {
  try {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid;
  } catch (error) {
    print('Error al obtener el ID del usuario: $error');
    return null;
  }
}
}
