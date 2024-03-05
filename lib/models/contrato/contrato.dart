class Contrato {
  String? id;
  String? cliente;
  String? casa;
  String? dtInicioContrato;
  String? dtFinalContrato;
  String? tempoContrato;
  String? valorMensal;
  String? dtVencimento;

  //construtor
  Contrato({
    this.id,
    this.cliente,
    this.casa,
    this.dtInicioContrato,
    this.dtFinalContrato,
    this.tempoContrato,
    this.valorMensal,
    this.dtVencimento,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente': cliente,
      'casa': casa,
      'dtInicioContrato': dtInicioContrato,
      'dtFinalContrato': dtFinalContrato,
      'tempoContrato': tempoContrato,
      'valorMensal': valorMensal,
      'dtVencimento': dtVencimento,
    };
  }

  Map<String, dynamic> toJsonid() {
    return {
      'id': id,
      
    };
  }
}


 // Verifica se snapshot.data não é nulo
       
  