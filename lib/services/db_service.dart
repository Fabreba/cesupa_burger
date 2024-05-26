import 'package:cesupa_burger/model/Avaliacao.dart';
import 'package:cesupa_burger/model/Hamburgueria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addHamburgueria({
    required String nome,
    required String descricao,
    required String endereco,
    required String contato,
    required String createdBy,
    required double precoMedio,
  }) async {
    try {
      await db.collection('hamburguerias').doc(nome).set({
        'descricao': descricao,
        'endereco': endereco,
        'contato': contato,
        'createdBy': createdBy,
        'precoMedio': precoMedio,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<Hamburgueria>> getHamburgueriasStream() {
    return db.collection('hamburguerias').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Hamburgueria(
          nome: doc.id,
          descricao: doc.data()['descricao'] as String,
          endereco: doc.data()['endereco'] as String,
          contato: doc.data()['contato'] as String,
          createdBy: doc.data()['createdBy'] as String,
          precoMedio: doc.data()['precoMedio'] as double,
          averageRating: doc.data()['averageRating'] ?? 0.0,
          ratingCount: doc.data()['ratingCount'] ?? 0,
        );
      }).toList();
    });
  }
  Future<void> updateHamburgueria({required String nome, required String newName, required double newPrecoMedio}) async {
  try {
    DocumentReference docRef = db.collection('hamburguerias').doc(nome);
    await db.runTransaction((transaction) async {
      transaction.update(docRef, {
        'nome': newName,
        'precoMedio': newPrecoMedio,
      });
    });
  } catch (e) {
    print(e);
  }
}


  Future<void> addAvaliacao({
    required String nome,
    required int nota,
    required String comentario,
  }) async {
    try {
      DocumentReference docRef = db.collection('hamburguerias').doc(nome);
      await db.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception("Hamburgueria does not exist!");
        }

        // Update the average rating
        double oldRating =
            (snapshot.data() as Map<String, dynamic>)['averageRating'] ?? 0.0;
        int ratingCount =
            (snapshot.data() as Map<String, dynamic>)['ratingCount'] ?? 0;
        double newRating =
            ((oldRating * ratingCount) + nota) / (ratingCount + 1);

        // Add the new review
        await docRef.collection('avaliacoes').add({
          'nota': nota,
          'comentario': comentario,
        });

        // Update the hamburgueria document
        transaction.update(docRef,
            {'averageRating': newRating, 'ratingCount': ratingCount + 1});
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Avaliacao>> getAvaliacoes({required String nome}) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('hamburguerias')
          .doc(nome)
          .collection('avaliacoes')
          .get();
      return querySnapshot.docs.map((doc) {
        return Avaliacao(
          nota: doc['nota'],
          comentario: doc['comentario'],
        );
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
