import 'package:cesupa_burger/model/Avaliacao.dart';

class Hamburgueria {
  String nome;
  String descricao;
  String endereco;
  String contato;
  String createdBy;
  double precoMedio;
  double averageRating;  // Add this line
  int ratingCount;       // Add this line
  List<Avaliacao> avaliacoes = [];
  Hamburgueria({
    required this.nome,
    required this.descricao,
    required this.endereco,
    required this.contato,
    required this.createdBy,
    required this.precoMedio,
    this.averageRating = 0.0,  // Initialize if not provided
    this.ratingCount = 0,
  });
}
