import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StreamBuilderPage extends StatefulWidget {
  @override
  _StreamBuilderPageState createState() => _StreamBuilderPageState();
}

class _StreamBuilderPageState extends State<StreamBuilderPage> {
  final _formKey = GlobalKey<FormState>();
  final _cepFieldController = TextEditingController();
  String cidade = 'Aguardando busca';

  StreamController<bool> _isLoadingStream = new StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingStream.sink;
  Stream<bool> get isLoadingOutput => _isLoadingStream.stream;

  Future<String> sendRequest(String cep) async {
    await Future.delayed(
      Duration(seconds: 3),
    );

    http.Response response =
        await http.get("https://viacep.com.br/ws/$cep/json/");

    return jsonDecode(response.body)['localidade'];
  }

  @override
  void dispose() {
    _isLoadingStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Indicador de progresso StreamBuilder",
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
                    isLoadingInput.add(true);

                    String response =
                        await this.sendRequest(_cepFieldController.text);

                    isLoadingInput.add(false);

                    setState(() {
                      this.cidade = response;
                    });
                  }
                },
                child: StreamBuilder<bool>(
                  stream: isLoadingOutput,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      );
                    }

                    return Text(
                      "Enviar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  },
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
