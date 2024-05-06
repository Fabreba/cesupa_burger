import 'package:cesupa_burger/screens/home_screen.dart'; // Certifique-se de importar a HomeScreen
import 'package:cesupa_burger/services/authentication_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final Authentication_Service _authService = Authentication_Service();
  bool _isLogin =
      true; // Estado para controlar se estamos no modo login ou registro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Cadastro',
            style: const TextStyle(color: Colors.blue)),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Seja Bem vindo ao CESUPA BURGUER!',
              style: TextStyle(fontSize: 24, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite sua senha';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin) // Campo adicional para confirmação de senha no registro
                    TextFormField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                          labelText: 'Confirme sua senha'),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_isLogin) {
                          try {
                            await _authService.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login realizado com sucesso!'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Erro ao realizar login! Erro: $e'),
                              ),
                            );
                          }
                        } else {
                          String message =
                              await _authService.registerWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                          print(message);
                          if (message == 'Sucesso') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Usuário registrado com sucesso!'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Erro ao registrar usuário! Erro: $message'),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Text(_isLogin ? 'Login' : 'Cadastrar'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin; // Alterna entre login e registro
                      });
                    },
                    child: Text(
                        _isLogin ? 'Criar uma conta' : 'Já tenho uma conta'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navega para a HomeScreen sem realizar login
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Continuar sem login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
