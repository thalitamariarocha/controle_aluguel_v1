class Cliente {
  String? id;
  String? nome;
  String? cpf;
  String? telefone;
  String? dtNascimento;
  String? email;

  //construtor
  Cliente({
    this.id,
    this.nome,
    this.cpf,
    this.telefone,
    this.dtNascimento,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'dtNascimento': dtNascimento,
      'email': email,
    };
  }

  Map<String, dynamic> toJsonid() {
    return {
      'id': id,
    };
  }
}
