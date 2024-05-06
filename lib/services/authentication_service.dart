import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  User? _user;

  AuthenticationProvider(this._firebaseAuth) {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    notifyListeners();
  }
}

class Authentication_Service {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? usuario;
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      // Handle any errors that occur during sign in
      print('Error signing in: $e');
      throw e;
    }
  }

  Future<String> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Sucesso";
    } on FirebaseAuthException catch (e) {
      // Handle any errors that occur during registration
      print('Error registering user: $e');
      return e.message.toString();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
