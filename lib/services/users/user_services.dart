import 'dart:js_interop';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_aluguel/models/usuarios/cliente.dart';
import 'package:controle_aluguel/models/usuarios/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserServices extends ChangeNotifier {
//obter instancia do firebase auth
  late String idParaImagem;
  Uint8List webImage = Uint8List(8);
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Usuario usuario = Usuario();
  Cliente cliente = Cliente();
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference get _collectionRef => _firestore.collection('usuario');
  Cliente _clienteModel = Cliente();

// registrar o usuario no firebase
  Future<bool> signUp(
      String email, String senha, nome, cpf, dtNascimento) async {
    try {
      User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: senha))
          .user;

      usuario.id = user!.uid;
      usuario.nome = nome;
      usuario.cpf = cpf;
      usuario.dtNascimento = dtNascimento;
      usuario.email = email;
      usuario.senha = senha;

      await saveUser(user.uid);
      return Future.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        debugPrint('email inválido');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('já existe cadastro com esse e-mail');
      } else {
        debugPrint(e.code);
      }
      return false;
    }
  }

  Future<void> saveUser(String id) async {
    try {
      String id = FirebaseAuth.instance.currentUser!.uid;
      final userDocRef = _firestore.collection('usuario').doc(id);

      if (!(await userDocRef.get()).exists) {
        // A coleção não existe, crie-a e insira os dados
        await userDocRef.set(usuario.toJson());
      } else {
        // A coleção já existe, atualize os dados conforme necessário
        await userDocRef.update(usuario.toJson());
      }

      print('Dados salvos com sucesso.');
    } catch (e) {
      print('Erro ao salvar os dados: $e');
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      (await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password));

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        debugPrint('email inválido');
      } else if (e.code == 'user-not-found') {
        debugPrint('usuário não cadastrado');
      } else {
        debugPrint('erro de plataforma');
      }
      return false;
    }
  }

  //------aqui em diante é cadastro do cliente----------

  Future<bool> cadastrarCliente(
      String nome, cpf, dtNascimento, telefone, email) async {
    cliente.nome = nome;
    cliente.cpf = cpf;
    cliente.telefone = telefone;
    cliente.dtNascimento = dtNascimento;
    cliente.email = email;

    cliente.toJson();

    try {
      final userDocRef = _firestore.collection('cliente').doc(cliente.cpf);

      if (!(await userDocRef.get()).exists) {
        // A coleção não existe, crie-a e insira os dados
        await userDocRef.set(cliente.toJson());
      } else {
        // A coleção já existe, atualize os dados conforme necessário
        await userDocRef.update(cliente.toJson());
      }

      cliente.id = userDocRef.id;

      await userDocRef.update(cliente.toJsonid());

      print('Dados salvos com sucesso.');
    } catch (e) {
      print('Erro ao salvar os dados: $e');
    }
    return Future.value(true);
  }

  deleteCadastro(id) async {
    try {
      await FirebaseFirestore.instance.collection('cliente').doc(id).delete();
      print('Dados excluídos com sucesso.');
    } catch (e) {
      print('Erro ao excluir os dados: $e');
    }
  }

  Future<void> loadDataFromFirebase(String id) async {
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance.collection('casa').doc(id).get();
      _clienteModel.id = id;
      _clienteModel.cpf = documentSnapshot['cpf'];
      _clienteModel.dtNascimento = documentSnapshot['dtNascimento'];
      _clienteModel.telefone = documentSnapshot['telefone'];
      _clienteModel.email = documentSnapshot['alugada'];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> cpfExists(cpf) async {
    final cpfRef = FirebaseFirestore.instance.collection('cliente');
    final snapshot = await cpfRef.doc(cpf).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  late String selectedCliente = '';

  Future<List<String>> loadNamesFromFirebase() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('cliente').get();
    final List<String> names = querySnapshot.docs
        .map((QueryDocumentSnapshot documentSnapshot) =>
            documentSnapshot['nome'] as String)
        .toList();

    if (!names.isEmpty && selectedCliente.isEmpty) {
      selectedCliente = names[0];
    }
    return names;
  }
}
