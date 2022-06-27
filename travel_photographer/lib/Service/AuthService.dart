import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signIn(
      String email, String password, BuildContext context) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return user.user!.displayName;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(e.toString())));
      }
    }
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<User?> register(String name, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    user.user!.updateDisplayName(name);

    return user.user;
  }
}
