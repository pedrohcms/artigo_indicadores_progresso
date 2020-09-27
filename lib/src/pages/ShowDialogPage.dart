import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowDialogPage extends StatefulWidget {
  @override
  _ShowDialogPageState createState() => _ShowDialogPageState();
}

class _ShowDialogPageState extends State<ShowDialogPage> {
  final _formKey = GlobalKey<FormState>();
  final _cepFieldController = TextEditingController();
  String cidade = 'Aguardando busca';

  Future<String> sendRequest(String cep) async {
    await Future.delayed(
      Duration(seconds: 3),
    );

    http.Response response =
        await http.get("https://viacep.com.br/ws/$cep/json/");

    return jsonDecode(response.body)['localidade'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Indicador de progresso showDialog",
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text("Digite seu CEP: "),
              ),
              TextFormField(
                controller: _cepFieldController,
                validator: (value) {
                  if (value.isEmpty) return 'O campo CEP não pode ser vazio';

                  return null;
                },
                decoration: InputDecoration(
                  hintText: "CEP",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("Carregando"),
                          content: Container(
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                        );
                      },
                    );

                    String response =
                        await this.sendRequest(_cepFieldController.text);

                    // Remove o AlertDialog
                    Navigator.pop(context);

                    setState(() {
                      this.cidade = response;
                    });
                  }
                },
                child: Text(
                  "Enviar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Cidade: $cidade"),
            ],
          ),
        ),
      ),
    );
  }
}
