import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_aluguel/models/casa/casa.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CasaServices {
  late String idParaImagem;
  Uint8List webImage = Uint8List(8);
  FirebaseStorage storage = FirebaseStorage.instance;
  Casa casaModel = Casa();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _collectionRef => _firestore.collection('casa');

  //essa função abaixo é para a listagem

  DocumentReference get _firestoreRef => _firestore.doc('casa/${casaModel.id}');

  Stream<QuerySnapshot> getAll() {
    return _collectionRef.snapshots();
  }

  //-------------------------------------------------------------------------------
//a partir daqui são funções para a excluir
  deleteCadastro(id) async {
    try {
      await FirebaseFirestore.instance.collection('casa').doc(id).delete();
      print('Dados excluídos com sucesso.');
    } catch (e) {
      print('Erro ao excluir os dados: $e');
    }
  }

  Future<bool> atualizaCasa(
      String id, nome, endereco, dynamic imageFile, alugada) async {
    try {
      String url = "";

      //Quero descobrir se o tipo é string ou Uint8List
      var ehString = imageFile.runtimeType;
      if (ehString != String) {
        print('Dados atualizados com sucesso.');

        Reference ref = storage.ref().child('casa').child(id);
        UploadTask task = ref.putData(
          imageFile,
          SettableMetadata(
            contentType: 'image/jpg',
          ),
        );

        url = await (await task.whenComplete(() {})).ref.getDownloadURL();
      } else {
        url = imageFile;
      }

      casaModel.id = id;
      casaModel.endereco = endereco;
      casaModel.image = url;
      casaModel.alugada = alugada;
      casaModel.toJson();
      await _firestoreRef.update(casaModel.toJson());

      // DocumentReference docRef = _collectionRef.doc(id);
      // await docRef.update({'image': url});

      print('imagem atualizada com sucesso.');

      return Future.value(true);
    } catch (e) {
      print('Erro ao atualizar os dados: $e');
      return Future.value(false);
    }
  }

  Future<void> loadDataFromFirebase(String id) async {
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance.collection('casa').doc(id).get();
      casaModel.id = id;
      casaModel.nome = documentSnapshot['nome'];
      casaModel.endereco = documentSnapshot['endereco'];
      casaModel.image = documentSnapshot['image'];
      casaModel.alugada = documentSnapshot['alugada'];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  //-------------------------------------------------------------------------------

  //a partir daqui são funções para o cadastro de casa

  late String selectedCasa = '';

  Future<List<String>> loadNamesFromFirebase() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('casa')
        .where("alugada", isEqualTo: 'false')
        .get();
    final List<String> names = querySnapshot.docs
        .map((QueryDocumentSnapshot documentSnapshot) =>
            documentSnapshot['nome'] as String)
        .toList();

    if (!names.isEmpty && selectedCasa.isEmpty) {
      selectedCasa = names[0];
    }
    return names;
  }

  Future<void> pickAndUploadImage() async {
    Image.memory(webImage);
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      var imageSelected = await image.readAsBytes();
      webImage = imageSelected;
    } else {
      debugPrint('Nenhuma imagem selecionada.');
    }
  }

  Future<bool> cadastrarCasa(String nome, endereco, dynamic imageFile) async {
    casaModel.nome = nome;
    casaModel.endereco = endereco;
    //casaModel.image = imageFile;
    casaModel.alugada = "false";
    casaModel.toJson();

    try {
      //String id = FirebaseAuth.instance.currentUser!.uid;
      final userDocRef = _firestore.collection('casa').doc();

      if (!(await userDocRef.get()).exists) {
        // A coleção não existe, crie-a e insira os dados
        await userDocRef.set(casaModel.toJson());
      } else {
        //cadOng.id = userDocRef.id;
        // A coleção já existe, atualize os dados conforme necessário
        await userDocRef.update(casaModel.toJson());
      }

      casaModel.id = userDocRef.id;

      await userDocRef.update(casaModel.toJsonid());

      Reference ref = storage.ref().child('casa').child(userDocRef.id);
      UploadTask task = ref.putData(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpg',
        ),
      );
      //SettableMetadata(contentType: 'image/jpeg');
      String url = await (await task.whenComplete(() {})).ref.getDownloadURL();
      DocumentReference docRef = _collectionRef.doc(userDocRef.id);
      await docRef.update({'image': url});
      print('Dados salvos com sucesso.');
    } catch (e) {
      print('Erro ao salvar os dados: $e');
    }
    return Future.value(true);
  }
}
