class Hamburgueria {
  final String nome;
  final String descricao;
  final String endereco;
  final String contato;
  final String createdBy;
  final double precoMedio;
  final double nota;

  Hamburgueria({
    required this.nome,
    required this.descricao,
    required this.endereco,
    required this.contato,
    required this.createdBy,
    required this.precoMedio,
    this.nota = 0.0,
  });  
}