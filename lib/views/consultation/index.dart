import 'package:flutter/material.dart';
import 'package:fteste/views/home/index.dart';

class ConfirmConsultationView extends StatefulWidget {

  final String consultationId;

  ConfirmConsultationView(this.consultationId);

  @override
  ConfirmConsultationViewState createState() {
    return new ConfirmConsultationViewState();
  }
}

class ConfirmConsultationViewState extends State<ConfirmConsultationView> {

  bool _confirmed;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: _confirmed == null ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            child: Text('Desconfirmar Consulta'),
            onPressed: () { setState(() {_confirmed = false;}); }
          ),
          RaisedButton(
            child: Text('Confirmar Consulta'),
            onPressed: () { setState(() {_confirmed = true;}); }
          ),
        ],
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Consulta ${_confirmed ? 'Confirmada.' : 'Desconfirmada.'}'),
          RaisedButton(child: Text('OK'),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeView()));
            }
          ),
        ],
      ),
    ),
  );
}