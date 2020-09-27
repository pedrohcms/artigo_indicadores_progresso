//import 'package:artigo_indicadores_progresso/src/pages/ShowDialogPage.dart';
//import 'package:artigo_indicadores_progresso/src/pages/StreamBuilderPage.dart';
import 'package:artigo_indicadores_progresso/src/pages/SnackBarPage.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Indicadores de Progresso",
      home: SnackbarPage(),
    );
  }
}
