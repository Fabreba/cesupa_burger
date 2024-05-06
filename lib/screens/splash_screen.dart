import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simula a verificação de autenticação
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // Usuário não está logado, redireciona para a tela de login
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Usuário está logado, redireciona para a tela home
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    // Enquanto verifica, mostra um indicador de carregamento
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
