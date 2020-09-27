import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SnackbarPage extends StatefulWidget {
  @override
  _SnackbarPageState createState() => _SnackbarPageState();
}

class _SnackbarPageState extends State<SnackbarPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Indicador de progresso SnackBar",
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
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.blue,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Carregando"),
                            SizedBox(
                              width: 10.0,
                            ),
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    );

                    String response =
                        await this.sendRequest(_cepFieldController.text);

                    _scaffoldKey.currentState.hideCurrentSnackBar();

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
