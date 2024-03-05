class Usuario {
  String? id;
  String? email;
  String? senha;
  String? cpf;
  String? dtNascimento;
  String? nome;

  //construtor
  Usuario({
    this.id,
    this.email,
    this.senha,
    this.cpf,
    this.dtNascimento,
    this.nome,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'senha': senha,
      'cpf': cpf,
      'dtNascimento': dtNascimento,
      'nome': nome,
    };
  }
}
