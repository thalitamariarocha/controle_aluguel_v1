import 'package:controle_aluguel/models/contrato/contrato.dart';
import 'package:controle_aluguel/pages/casa/cad_casa_page.dart';
import 'package:controle_aluguel/pages/contratos/cad_contrato_page.dart';
import 'package:controle_aluguel/services/contrato/contrato_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ContratoServices _contratoServices = ContratoServices();

class teste extends StatefulWidget {
  const teste({super.key});

  @override
  State<teste> createState() => _testeState();
}

class _testeState extends State<teste> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      Scaffold(
          appBar: AppBar(
            title: const Text("Contratos"),
          ),
          body: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  width: 900,
      
                  // width: MediaQuery.of(context).size.width *
                  //     0.8, // 80% da largura da tela
                  // height: MediaQuery.of(context).size.height *
                  //     0.3, // 30% da altura da tela
      
                  child: FutureBuilder<List<Contrato>>(
                    future: _contratoServices.allContratos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.data == null) {
                        return const Text('Sem dados cadastrados');
                      }
      
                      // if (snapshot.connectionState ==
                      //     ConnectionState.waiting) {
                      //   return CircularProgressIndicator();
                      // }
      
                      if (snapshot.data != null) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            // Acessa os campos casa e cliente e fornece um valor padrão caso sejam nulos
                            final casa =
                                snapshot.data![index].casa ?? 'No data';
                            final cliente =
                                snapshot.data![index].cliente ?? 'No data';
      
                            return ListTile(
                              title: Text(casa),
                              subtitle: Text(cliente),
                              trailing: Row(
                                children: [
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
                                      // if (snapshot.data![index].id != null) {
                                      //   _contratoServices.deleteContrato(
                                      //       snapshot.data![index].id ?? '');
                                      // }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        // Se snapshot.data for nulo, exibe uma mensagem de erro ou um indicador de carregamento
                        return Text('No data available');
                      }
                    },
                  )),
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
          ))
    ]);
  }
}
