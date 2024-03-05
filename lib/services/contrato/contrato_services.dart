import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_aluguel/models/contrato/contrato.dart';

Contrato contratoModel = Contrato();
final CollectionReference contratoCollection =
    FirebaseFirestore.instance.collection('contrato');
final CollectionReference casaCollection =
    FirebaseFirestore.instance.collection('casa');
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ContratoServices {
  Future<List<Contrato>> allContratos() async {
    QuerySnapshot querySnapshot = await contratoCollection.get();
    return querySnapshot.docs.map((doc) {
      return Contrato(
        id: doc.id,
        cliente: doc['cliente'],
        casa: doc['casa'],
        valorMensal: doc['valorMensal'],
        dtInicioContrato: doc['dtInicioContrato'],
        dtFinalContrato: doc['dtFinalContrato'],
      );
    }).toList();
  }

  Future<bool> cadastrarContrato(cliente, casa, dtInicioContrato,
      dtFinalContrato, tempoContrato, valorMensal, dtVencimento) async {
    contratoModel.cliente = cliente;
    contratoModel.casa = casa;
    contratoModel.dtInicioContrato = dtInicioContrato;
    contratoModel.dtFinalContrato = dtFinalContrato;
    contratoModel.tempoContrato = tempoContrato;
    contratoModel.valorMensal = valorMensal;
    contratoModel.dtVencimento = dtVencimento;
    contratoModel.toJson();

    try {
      final userDocRef = _firestore.collection('contrato').doc();
      final atualizaStatus = _firestore.collection('casa');

      if (!(await userDocRef.get()).exists) {
        // A coleção não existe, crie-a e insira os dados
        await userDocRef.set(contratoModel.toJson());
      } else {
        // A coleção já existe, atualize os dados conforme necessário
        await userDocRef.update(contratoModel.toJson());
      }

      contratoModel.id = userDocRef.id;

      await userDocRef.update(contratoModel.toJsonid());

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('casa')
          .where('nome', isEqualTo: casa)
          .get();

      querySnapshot.docs.forEach((doc) {
        atualizaStatus.doc(doc.id).update({'alugada': 'true'});
      });

      print('Dados salvos com sucesso.');
    } catch (e) {
      print('Erro ao salvar os dados: $e');
    }
    return Future.value(true);
  }

  Future<void> updateContrato(Contrato contrato) async {
    await contratoCollection.doc(contrato.id).update(contrato.toJson());
  }

  Future<void> deleteContrato(String id, casa) async {
    await contratoCollection.doc(id).delete();

    // await casaCollection.doc().where('nome', isEqualTo: casa).get().then((value) {
    //   value.docs.forEach((element) {
    //     casaCollection.doc(element.id).update({'alugada': 'false'});
    //   });
    // });

    //teste teste
  }

  Future<void> loadDataFromFirebase(String id) async {
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance.collection('contrato').doc(id).get();
      contratoModel.id = id;
      contratoModel.cliente = documentSnapshot['cliente'];
      contratoModel.casa = documentSnapshot['casa'];
      contratoModel.dtInicioContrato = documentSnapshot['dtInicioContrato'];
      contratoModel.dtFinalContrato = documentSnapshot['dtFinalContrato'];
      contratoModel.tempoContrato = documentSnapshot['tempoContrato'];
      contratoModel.valorMensal = documentSnapshot['valorMensal'];
      contratoModel.dtVencimento = documentSnapshot['dtVencimento'];
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
