import 'package:cesupa_burger/model/AuthModel.dart';
import 'package:cesupa_burger/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hamburgueria {
  final String nome;
  final double nota;
  final double precoMedio;

  Hamburgueria(
      {required this.nome, required this.nota, required this.precoMedio});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Authentication_Service _authService = Authentication_Service();

  @override
  Widget build(BuildContext context) {
    // Lista mockada de hambúrgueres
    final List<Hamburgueria> hamburguerias = [
      Hamburgueria(nome: "Classic Burger", nota: 4.5, precoMedio: 12.99),
      Hamburgueria(nome: "Cheese Burger", nota: 4.8, precoMedio: 14.99),
      Hamburgueria(nome: "Veggie Burger", nota: 4.2, precoMedio: 11.99),
      Hamburgueria(nome: "Veggie Burger", nota: 4.2, precoMedio: 11.99),
      Hamburgueria(nome: "Veggie Burger", nota: 4.2, precoMedio: 11.99),
      Hamburgueria(nome: "Cheese Burger", nota: 4.2, precoMedio: 11.99),
      Hamburgueria(nome: "Veggie Burger", nota: 4.8, precoMedio: 14.99),
      Hamburgueria(nome: "Veggie Burger", nota: 4.2, precoMedio: 11.99),
      Hamburgueria(nome: "Cheese Burger", nota: 4.2, precoMedio: 11.99),
      Hamburgueria(nome: "Veggie Burger", nota: 4.8, precoMedio: 14.99),
      Hamburgueria(nome: "Veggie Burger", nota: 4.2, precoMedio: 11.99),
      Hamburgueria(nome: "Veggie Burger", nota: 4.2, precoMedio: 11.99),
      Hamburgueria(nome: "King Burger", nota: 4.2, precoMedio: 11.99),
      // Adicione mais itens conforme necessário
    ];

    // Verifica se o usuário está logado
    final bool isUserLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (isUserLoggedIn) {
                _authService.signOut();
              }
              AuthModel auth = Provider.of<AuthModel>(context, listen: false);
                auth.logout();
            },
            child: Text(isUserLoggedIn ? 'Sair' : 'Voltar'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isUserLoggedIn
                ? const Text('Bem vindo!')
                : const Text('Cadastre-se para adicionar mais hamburguerias!'),
            Expanded(
              child: ListView.builder(
                itemCount: hamburguerias.length,
                itemBuilder: (context, index) {
                  final hamburguer = hamburguerias[index];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            hamburguer.nome,
                            style: const TextStyle(
                                color: Color.fromRGBO(1, 3, 39, 0.612)),
                          ),
                          subtitle: Text(
                              'Nota: ${hamburguer.nota} - Preço Médio: R\$${hamburguer.precoMedio.toStringAsFixed(2)}'),
                          trailing: const Icon(Icons
                              .arrow_forward), // Ícone de seta para a direita
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isUserLoggedIn
          ? FloatingActionButton(
              onPressed: () {
                // Ação para adicionar um novo hambúrguer
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
