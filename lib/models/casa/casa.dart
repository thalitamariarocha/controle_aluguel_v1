class Casa {
  String? id;
  String? nome;
  String? endereco;
  String? image;
  String? alugada = "false";

  //construtor
  Casa({
    this.id,
    this.nome,
    this.endereco,
    this.image,
    this.alugada,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'image': image,
      'alugada': alugada,
    };
  }

  Map<String, dynamic> toJsonid() {
    return {
      'id': id,
    };
  }
}
