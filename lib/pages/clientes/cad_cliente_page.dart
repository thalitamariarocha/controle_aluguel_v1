import 'dart:html';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:controle_aluguel/pages/login/login_page.dart';
import 'package:controle_aluguel/services/dialogs.dart';
import 'package:controle_aluguel/services/users/user_services.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

class CadastroCliente extends StatelessWidget {
  CadastroCliente({Key? key}) : super(key: key);

  final TextEditingController _email = TextEditingController();
  final TextEditingController _telefone = TextEditingController();
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
        title: const Text("Cadastro de Inquilino"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Column(children: [
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
          TextFormField(
            controller: _dtnascimento,
            decoration: const InputDecoration(
              labelText: 'Data de nascimento',
              hintText: 'DD/MM/AAAA',
              prefixIcon: Icon(Icons.calendar_today),
            ),
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
            controller: _telefone,
            decoration: const InputDecoration(
              labelText: 'Celular',
              hintText: 'xx-xxxxx-xxxx',
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              MultiMaskedTextInputFormatter(
                masks: ['xx-xxxxx-xxxx'],
                separator: '-',
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
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
                        _telefone.text.isEmpty ||
                        _nome.text.isEmpty ||
                        _cpf.text.isEmpty ||
                        _dtnascimento.text.isEmpty) {
                      _dialogs.showErrorDialog(
                          context, 'todos os campos devem ser preenchidos');
                      return;
                    }

                    bool exists = await _userServices.cpfExists(_cpf.text);
                    if (exists == true) {
                      print('CPF já existe no Firebase.');
                      _dialogs.showErrorDialog(context, "CPF já cadastrado");
                    } else {
                      if (await _userServices.cadastrarCliente(
                        _nome.text,
                        _cpf.text,
                        _dtnascimento.text,
                        _telefone.text,
                        _email.text,
                      )) {
                        Navigator.pop(context);
                      } else {
                        debugPrint("erro, favor repetir");
                      }
                    }
                  }, //chamada do signup do user_services (controller)
                  child: const Text(
                    "Salvar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ]),
      ),
    );
  }
}
