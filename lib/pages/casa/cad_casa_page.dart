import 'dart:html';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:controle_aluguel/pages/login/login_page.dart';
import 'package:controle_aluguel/services/casa/casa_services.dart';
import 'package:controle_aluguel/services/dialogs.dart';
import 'package:controle_aluguel/services/users/user_services.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

class CadCasaPage extends StatelessWidget {
  CadCasaPage({Key? key}) : super(key: key);

  final TextEditingController _endereco = TextEditingController();
  final TextEditingController _nome = TextEditingController();
  CasaServices _casaServices = CasaServices();
  Dialogs _dialogs = Dialogs();

  late String urlImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Imóvel"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 50, left: 50),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
              controller: _nome,
              decoration: const InputDecoration(
                labelText: "Nome do empreendimento",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _endereco,
              decoration: const InputDecoration(
                labelText: "Endereço completo",
              ),
            ),
            SizedBox(height: 10),

            //-------------------------------------------------------------------------------
            // carregar imagem

            SizedBox(height: 30),
            const Row(
              children: [
                Text('Insira abaixo a imagem do imóvel: '),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: LinearBorder.bottom(),
              ),
              onPressed: () async {
                await _casaServices.pickAndUploadImage();
              },
              child: const Text('selecione aqui'),
            ),

            const SizedBox(height: 15),

            //------------------------------------------------------------------

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
                      if (_nome.text.isEmpty || _endereco.text.isEmpty) {
                        _dialogs.showErrorDialog(
                            context, 'todos os campos devem ser preenchidos');
                        return;
                      }

                      if (await _casaServices.cadastrarCasa(
                        _nome.text,
                        _endereco.text,
                        _casaServices.webImage,
                      )) {
                        _dialogs.showSuccessDialog(context, "cadastro salvo!");
                        _endereco.clear();
                        _nome.clear();
                      } else {
                        debugPrint("erro, favor repetir");
                      }
                    },
                    child: const Text(
                      "Salvar",
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
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
