// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_aluguel/pages/home.dart';
import 'package:controle_aluguel/pages/login/signup_page.dart';
import 'package:controle_aluguel/services/dialogs.dart';
import 'package:controle_aluguel/services/users/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  UserServices _userServices = UserServices();
  Dialogs _dialogs = Dialogs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 50, left: 50),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            //ver centralização aqui
            const Icon(
              Icons.home_work_outlined,
              size: 100.0,
              color: Color.fromRGBO(4, 121, 9, 1),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "email",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              controller: _password,
              decoration: const InputDecoration(
                labelText: "senha",
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 5.0,
                bottom: 10.0,
              ),
              alignment: Alignment.bottomRight,
            ),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: LinearBorder.bottom(),
                  ),
                  onPressed: () async {
                    if (await _userServices.signIn(
                            _email.text, _password.text) ==
                        true) {
                      final user = FirebaseAuth.instance.currentUser;
                      final userData = await FirebaseFirestore.instance
                          .collection('usuario')
                          .doc(user?.uid)
                          .get();
                      if (userData.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      } else {
                        _dialogs.showErrorDialog(
                            context, "Erro de usuário/senha");
                      }
                    } else {
                      _dialogs.showErrorDialog(
                          context, "Não existe o e-mail cadastrado no sistema");
                    }
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                  ),
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "ainda não tem conta? registre-se",
                      style: TextStyle(color: Color.fromARGB(255, 61, 6, 112)),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
