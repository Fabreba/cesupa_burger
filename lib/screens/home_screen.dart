import 'package:cesupa_burger/model/AuthModel.dart';
import 'package:cesupa_burger/model/Hamburgueria.dart';
import 'package:cesupa_burger/services/authentication_service.dart';
import 'package:cesupa_burger/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Authentication_Service _authService = Authentication_Service();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _contatoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _enderecoController.dispose();
    _contatoController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    final Database store_service = Database();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Hamburgueria'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _descricaoController,
                        decoration:
                            const InputDecoration(labelText: 'Descrição'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a descrição';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _enderecoController,
                        decoration:
                            const InputDecoration(labelText: 'Endereço'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o endereço';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _contatoController,
                        decoration: const InputDecoration(labelText: 'Contato'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o contato';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  store_service.addHamburgueria(
                      nome: _nomeController.text,
                      descricao: _descricaoController.text,
                      endereco: _enderecoController.text,
                      contato: _contatoController.text,
                      createdBy: FirebaseAuth.instance.currentUser!.uid);
                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Hamburgueria>>(
        future: Database().getHamburguerias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final hamburguerias = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isUserLoggedIn
                      ? const Text('Bem vindo!')
                      : const Text(
                          'Cadastre-se para adicionar mais hamburguerias!'),
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
                          child: ListTile(
                            title: Text(
                              hamburguer.nome,
                              style: const TextStyle(
                                  color: Color.fromRGBO(1, 3, 39, 0.612)),
                            ),
                            subtitle: Text(
                                'Nota: ${hamburguer.nota} - Preço Médio: R\$${hamburguer.precoMedio.toStringAsFixed(2)}'),
                            trailing: const Icon(Icons.arrow_forward),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Nenhuma hamburgueria encontrada'));
          }
        },
      ),
      floatingActionButton: isUserLoggedIn
          ? FloatingActionButton(
              onPressed: _showAddDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
