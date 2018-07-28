import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


void main() {

  runApp(new MaterialApp(title: 'Excelência - Cadastro', debugShowCheckedModeBanner: false, home: new cadastro()));
}

class cadastro extends StatelessWidget {
  String nome = "";
  String tel = "";
  String end = "";
  String gps = "";
  String foto = "";
  String cpf = "";
  String estado = "";
  String cidade = "";
  String email = "";
  String senha = "";
  //String url = "http://192.168.0.14:32768/api/cadastro";

  @override
  Widget build(BuildContext context) {
    // nome
    TextField nomeField = new TextField(
      keyboardType: TextInputType.text,
      onSubmitted: (String str) {
        nome = str;
      },
      decoration: new InputDecoration(labelText: "Nome do Paciente"),
    );

    // tel
    TextField telField = new TextField(
        decoration: new InputDecoration(
            labelText: "Telefone (Celular)", hintText: ""),
        keyboardType: TextInputType.number,
        onSubmitted: (String value) {
          tel = value;
        }
    );

    // cpf
    TextField cpfField = new TextField(
        decoration: new InputDecoration(labelText: "CPF", hintText: ""),
        keyboardType: TextInputType.number,
        onSubmitted: (String value) {
          cpf = value;
        }
    );

    // end
    TextField endField = new TextField(
        decoration: new InputDecoration(labelText: "Endereço", hintText: ""),
        keyboardType: TextInputType.text,
        onSubmitted: (String value) {
          end = value;
        }
    );

    // end
    TextField cidadeField = new TextField(
        decoration: new InputDecoration(labelText: "Cidade", hintText: ""),
        keyboardType: TextInputType.text,
        onSubmitted: (String value) {
          cidade = value;
        }
    );

    // end
    TextField estadoField = new TextField(
        decoration: new InputDecoration(labelText: "Estado", hintText: ""),
        keyboardType: TextInputType.text,
        onSubmitted: (String value) {
          estado = value;
        }
    );

    // login
    TextField emailField = new TextField(
        decoration: new InputDecoration(labelText: "e-mail", hintText: ""),
        keyboardType: TextInputType.emailAddress,
        onSubmitted: (String value) {
          email = value;
        }
    );

    // senha
    TextField senhaField = new TextField(
        decoration: new InputDecoration(labelText: "senha", hintText: ""),
        keyboardType: TextInputType.text,
        onSubmitted: (String value) {
          senha = value;
        }
    );

    // Create button
    RaisedButton okButton;
    okButton = new RaisedButton(
        child: new Text("Cadastrar"),
        onPressed: () {
          // ignore: referenced_before_declaration
          assincrona(nome,email,cidade,estado,senha,end,cpf, tel);
          // Generate dialo
          AlertDialog
          dialog
          =
          new
          AlertDialog
            (
              content:
              new Text ("cadastrado com sucesso!"));
          // Show dialog
          showDialog
            (
              context:
              context,
              // ignore: deprecated_member_use
              child:
              dialog
          );
        });

    Container container = new Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
            children: [
              nomeField,
              telField,
              cpfField,
              endField,
              cidadeField,
              estadoField,
              emailField,
              senhaField,
              okButton
            ]));

    AppBar appBar = new AppBar(title: new Text("Excelência - Cadastro"),
        backgroundColor: Colors.black);

    Scaffold scaffold = new Scaffold(appBar: appBar, body: container);
    return scaffold;
  }

  void assicrona() async {
    String url = "http://192.168.0.14:32768/api/cadastro";
    await http.post(Uri.encodeFull(url), body: {
      "email": "teste@teste.com",
      "senha": "123",
      "telefone": "23233333",
      "endereco": "gtes",
      "estado": "GO",
      "cpf": "2345678",
      "nome": "teste"
    });
  }
}

void assincrona(String nome,email,cidade,estado,senha,end,cpf, tel) async{
  String url = "http://192.168.0.6:32768/api/cadastro";
  final result = await http.post(Uri.encodeFull(url), body: {
    "email": email,
    "senha": senha,
    "telefone": tel,
    "endereco": end,
    "estado": estado,
    "cpf": cpf,
    "cidade": cidade,
    "nome": nome
  });
  print(result.statusCode);
}

Upload(File imageFile) async {
  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  var uri = Uri.parse(uploadURL);

  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));
  //contentType: new MediaType('image', 'png'));

  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}