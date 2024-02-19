import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../Design/menu_principal.dart';
import 'package:http/http.dart' as http;

class FirebaseAuthServ {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await _auth.currentUser;
  }

  Future<User?> SignUpPassAndEmail(String email, String password) async {
    if (password != null) {
      try {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        return credential.user;
      } catch (e) {
        print('Ha ocurrido un error');
      }
    }
    return null;
  }

  Future<User?> SignInPassAndEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException {}
    return null;
  }

 signInGoogle(BuildContext context) async {
  try {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();


    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      UserCredential result =
          await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;


    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        'email': userDetails!.email,
        'name': userDetails.displayName,
        'imageLink': userDetails.photoURL,
        'id': userDetails.uid
      };
      await DataBase().addUser(userDetails.uid, userInfoMap).then((value) =>
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PantallaMenuPrincipal())));
    }
  } catch (e) {
    print('Ocurrió un error durante la autenticación con Google: $e');
    // Puedes mostrar un mensaje de error al usuario o realizar otras acciones según sea necesario
  }
}

  Future signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${loginResult.accessToken!.token}'));

        final profile = jsonDecode(graphResponse.body);

        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        UserCredential result =
            await _auth.signInWithCredential(facebookAuthCredential);

        User? userDetails = result.user;

        if (result != null) {
          // Save user data to Firestore
          Map<String, dynamic> userInfoMap = {
            'email': userDetails!.email,
            'name': userDetails.displayName,
            'Imagelink': userDetails.photoURL,
            'id': userDetails.uid
          };
          await DataBase().addUser(userDetails.uid, userInfoMap);

          // Navigate to main menu screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PantallaMenuPrincipal()));
        }
      } else {
        print(
            'Error durante la autenticación con Facebook: ${loginResult.message}');
        // Puedes mostrar un mensaje de error al usuario o realizar otras acciones según sea necesario
      }
    } catch (e) {
      print('Ocurrió un error durante la autenticación con Facebook: $e');
      // Puedes mostrar un mensaje de error al usuario o realizar otras acciones según sea necesario
    }
  }

  // Create a credential from the access token

  // // Once signed in, return the UserCredential
  //
}
