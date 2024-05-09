import 'package:cesupa_burger/model/Hamburgueria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> addHamburgueria({
    required nome,
    required descricao,
    required endereco,
    required contato,
    required createdBy,
  }) async {
    try {
      await db.collection('hamburguerias').add({
        'nome': nome,
        'descricao': descricao,
        'endereco': endereco,
        'contato': contato,
        'createdBy': createdBy,
      });
    } catch (e) {
      print(e);
    }
  }
  Future<List<Hamburgueria>> getHamburguerias() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('hamburguerias').get();
      List<Hamburgueria> hamburguerias = querySnapshot.docs.map((doc) {
        return Hamburgueria(
          nome: doc['nome'],
          descricao: doc['descricao'],
          endereco: doc['endereco'],
          contato: doc['contato'],
          // Supondo que Hamburgueria tenha um campo createdBy
          createdBy: doc['createdBy'],
        );
      }).toList();
      return hamburguerias;
    } catch (e) {
      print(e);
      return [];
    }
  }
  
}
