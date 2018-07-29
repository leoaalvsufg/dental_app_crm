import 'dart:async' show Future;
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:fteste/views/consultation/index.dart';

class HomeView extends StatefulWidget {
  static const String tag = '/home';

  @override
  HomeViewState createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool _consulted = false;

  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmConsultationView(payload)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: _consulted ? Text('Consulta Marcarda!') :
        RaisedButton(
          child: Text('Agendar Consulta com Dr. Arruda.'),
          onPressed: () async {
            await _scheduleNotification('Confirme a sua consulta', // Exemplo da notificação após agendamento.
              'Consulta com o Dr. Arruda', 'consultationID',
              DateTime.now().add(Duration(seconds: 30)), // Data da consulta
              Duration(seconds: 20)); // Tempo para mostrar antes da data da consulta, irá mostrar após 10 segundos.
            setState(() { _consulted = true; });
          }
        ),
    ),
  );

  Future _scheduleNotification(String title, String body,
    String payload, DateTime consultationDate, Duration anticipatedTime) async {
    var scheduledNotificationDateTime =
      consultationDate.subtract(anticipatedTime);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId', 'Channel Agendamento', 'Agendamento de Consultas',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        0, title, body, scheduledNotificationDateTime,
        platformChannelSpecifics, payload: payload);
  }
}