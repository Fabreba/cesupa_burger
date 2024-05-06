import 'package:cesupa_burger/screens/home_screen.dart';
import 'package:cesupa_burger/screens/login_screen.dart';
import 'package:cesupa_burger/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define a tela inicial
      initialRoute: '/',
      routes: {
        '/': (context) =>
            SplashScreen(), // Tela de splash para verificação de autenticação
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
