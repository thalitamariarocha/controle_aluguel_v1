import 'package:controle_aluguel/models/contrato/contrato.dart';
import 'package:controle_aluguel/pages/casa/cad_casa_page.dart';
import 'package:controle_aluguel/pages/contratos/cad_contrato_page.dart';
import 'package:controle_aluguel/services/contrato/contrato_services.dart';
import 'package:controle_aluguel/services/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ContratoServices _contratoServices = ContratoServices();
Dialogs _dialogsService = Dialogs();

class ListaContrato extends StatefulWidget {
  const ListaContrato({super.key});

  @override
  State<ListaContrato> createState() => _TestePageState();
}

class _TestePageState extends State<ListaContrato> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Contratos"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<Contrato>>(
                future: _contratoServices.allContratos(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.data == null) {
                    return const Text('Sem dados cadastrados');
                  }

                  if (snapshot.data != null) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // Acessa os campos casa e cliente e fornece um valor padrão caso sejam nulos
                        final casa = snapshot.data![index].casa ?? 'No data';
                        final cliente =
                            snapshot.data![index].cliente ?? 'No data';

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(casa),
                            Text(cliente),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => CadCasaPage(),
                                //   ),
                                // );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Deletar Contrato'),
                                      content: const Text(
                                          'Deseja realmente Deletar o contrato?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // Fechar o diálogo quando o botão "Cancelar" for pressionado
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await _contratoServices
                                                .deleteContrato(
                                                    snapshot.data![index].id ??
                                                        '',
                                                    snapshot.data![index]
                                                            .casa ??
                                                        '');
                                          },
                                          child: const Text('Excluir'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Se snapshot.data for nulo, exibe uma mensagem de erro ou um indicador de carregamento
                    return Text('No data available');
                  }
                },
              ),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(300, 50)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadContratoPage(),
                      ),
                    );
                  },
                  child: const Text('Novo Contrato'),
                ),
              ),
            ],
          ),
        ));
  }
}
