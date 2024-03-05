import 'dart:html';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:controle_aluguel/pages/login/login_page.dart';
import 'package:controle_aluguel/services/dialogs.dart';
import 'package:controle_aluguel/services/users/user_services.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _dtnascimento = TextEditingController();
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _nome = TextEditingController();
  UserServices _userServices = UserServices();
  Dialogs _dialogs = Dialogs();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  late String urlImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastre-se"),
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 50, left: 50),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
              controller: _nome,
              decoration: const InputDecoration(
                labelText: "Nome Completo",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _cpf,
              decoration: const InputDecoration(
                labelText: "CPF",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                // obrigatório
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
            ),
            SizedBox(height: 10),

            //-------------------------------------//dt nascimento

            TextFormField(
              controller: _dtnascimento,
              decoration: const InputDecoration(
                labelText: 'Data de nascimento',
                hintText: 'DD/MM/AAAA',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              //keyboardType: TextInputType.datetime,
              inputFormatters: [
                MultiMaskedTextInputFormatter(
                  masks: ['DD/MM/YYYY'],
                  separator: '/',
                ),
              ],
            ),
            SizedBox(height: 10),

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
            const SizedBox(height: 15),

            //-------------------------------------------------------------------------------
            // carregar imagem teste

            Row(
              //botao voltar e cadastrar
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child:
                      //botao registrar
                      ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: LinearBorder.bottom(),
                    ),

                    onPressed: () async {
                      if (_email.text.isEmpty ||
                          _password.text.isEmpty ||
                          _nome.text.isEmpty ||
                          _cpf.text.isEmpty ||
                          _dtnascimento.text.isEmpty) {
                        _dialogs.showErrorDialog(
                            context, 'todos os campos devem ser preenchidos');
                        return;
                      }
                      if (_password.text.length < 6) {
                        debugPrint("senha menor que 6 caracteres");
                        return;
                      }
                      if (await _userServices.signUp(
                        _email.text,
                        _password.text,
                        _nome.text,
                        _cpf.text,
                        _dtnascimento.text,
                      )) {
                        Navigator.pop(context);
                      } else {
                        debugPrint("erro, favor repetir");
                      }
                    }, //chamada do signup do user_services (controller)
                    child: const Text(
                      "Registrar",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ],
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
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  "já tem conta? Login",
                  style: TextStyle(color: Color.fromARGB(255, 61, 6, 112)),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
