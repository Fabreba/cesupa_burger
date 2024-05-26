import 'package:cesupa_burger/model/AuthModel.dart';
import 'package:cesupa_burger/model/Avaliacao.dart';
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
  final _precoMedioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _enderecoController.dispose();
    _contatoController.dispose();
    _precoMedioController.dispose();
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
                      TextFormField(
                        controller: _precoMedioController,
                        decoration:
                            const InputDecoration(labelText: 'Preço Médio'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o Preço Médio';
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
                      createdBy: FirebaseAuth.instance.currentUser!.uid,
                      precoMedio: double.parse(_precoMedioController.text));
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
              _authService.signOut();
              AuthModel auth = Provider.of<AuthModel>(context, listen: false);
              auth.logout();
            },
            child: Text(isUserLoggedIn ? 'Sair' : 'Voltar'),
          ),
        ],
      ),
      body: StreamBuilder<List<Hamburgueria>>(
        stream: Database().getHamburgueriasStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final hamburguerias = snapshot.data!;
            return ListView.builder(
              itemCount: hamburguerias.length,
              itemBuilder: (context, index) {
                final hamburguer = hamburguerias[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HamburgueriaDetalhes(hamburgueria: hamburguer),
                      ),
                    );
                  },
                  child: Container(
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
                        'Nota média: ${hamburguer.averageRating.toStringAsFixed(1)} - Preço Médio: R\$${hamburguer.precoMedio.toStringAsFixed(2)}',
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  ),
                );
              },
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

class HamburgueriaDetalhes extends StatefulWidget {
  final Hamburgueria hamburgueria;

  HamburgueriaDetalhes({Key? key, required this.hamburgueria})
      : super(key: key);

  @override
  _HamburgueriaDetalhesState createState() => _HamburgueriaDetalhesState();
}

class _HamburgueriaDetalhesState extends State<HamburgueriaDetalhes> {
  List<Widget> reviewWidgets = [];
  final bool isUserLoggedIn = FirebaseAuth.instance.currentUser != null;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    var db = Database();
    var avaliacoes = await db.getAvaliacoes(nome: widget.hamburgueria.nome);
    setState(() {
      reviewWidgets = avaliacoes.map((review) {
        return _buildReviewCard(review);
      }).toList();
    });
  }

  Widget _buildReviewCard(Avaliacao review) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.amber),
        title: Row(
          children: [
            SizedBox(width: 10),
            _buildRatingStars(review.nota),
          ],
        ),
        subtitle: Text(review.comentario),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    final _notaController = TextEditingController();
    final _comentarioController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Avaliação'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _notaController,
                    decoration: InputDecoration(labelText: 'Nota'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma nota';
                      }
                      final rating = int.tryParse(value);
                      if (rating == null || rating < 1 || rating > 5) {
                        return 'Por favor, insira um número entre 1 e 5';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _comentarioController,
                    decoration: InputDecoration(labelText: 'Comentário'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um comentário';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final Database dbService = Database();
                  dbService
                      .addAvaliacao(
                    nome: widget.hamburgueria.nome,
                    nota: int.parse(_notaController.text),
                    comentario: _comentarioController.text,
                  )
                      .then((_) {
                    _loadReviews(); // Refresh the list of reviews
                    Navigator.of(context).pop();
                  });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hamburgueria.nome),
        backgroundColor: Colors.amber,
        actions: [
          if (FirebaseAuth.instance.currentUser?.uid ==
              widget.hamburgueria.createdBy)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _showEditDialog,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Endereço: ${widget.hamburgueria.endereco}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.description, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Descrição: ${widget.hamburgueria.descricao}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Contato: ${widget.hamburgueria.contato}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Preço Médio: R\$${widget.hamburgueria.precoMedio.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Avaliações',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...reviewWidgets, // Using spread operator to insert widgets
          ],
        ),
      ),
      floatingActionButton: isUserLoggedIn
          ? FloatingActionButton(
              child: const Icon(Icons.comment),
              backgroundColor: Colors.amber,
              onPressed: () => _showAddReviewDialog(context),
            )
          : null,
    );
  }

  void _showEditDialog() {
    final _formKey = GlobalKey<FormState>();
    if (FirebaseAuth.instance.currentUser?.uid !=
        widget.hamburgueria.createdBy) {
      return; // Early exit if the user is not the creator
    }

    final _nomeController = TextEditingController(text: widget.hamburgueria.nome);
    final _descricaoController = TextEditingController(text: widget.hamburgueria.descricao);
    final _enderecoController = TextEditingController(text: widget.hamburgueria.endereco);
    final _contatoController = TextEditingController(text: widget.hamburgueria.contato);
    final _precoMedioController = TextEditingController(text: widget.hamburgueria.precoMedio.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Hamburgueria'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a Descrição';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _enderecoController,
                  decoration: InputDecoration(labelText: 'Endereço'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o Endereço';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contatoController,
                  decoration: InputDecoration(labelText: 'Contato'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o Contato';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _precoMedioController,
                  decoration: InputDecoration(labelText: 'Preço Médio'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o Preço Médio';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Database().updateHamburgueria(
                    nome: widget.hamburgueria.nome,
                    newName: _nomeController.text,
                    newPrecoMedio: double.parse(_precoMedioController.text),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
