import 'package:flutter/material.dart';

import 'package:fteste/views/home/index.dart';
import 'package:fteste/views/login/index.dart';
import 'package:fteste/views/register/index.dart';

class Routes {
  bool _isAuthenticated = false;

  Routes() {
    runApp(MaterialApp(
      title: "Excelência",
      debugShowCheckedModeBanner: false,
      home: _isAuthenticated ? HomeView() : LoginView(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case LoginView.tag:
            return MyCustomRoute(
              builder: (_) => LoginView(),
              settings: settings,
            );

          case HomeView.tag:
            return MyCustomRoute(
              builder: (_) => HomeView(),
              settings: settings,
            );

          case RegisterView.tag:
            return MyCustomRoute(
              builder: (_) => RegisterView(),
              settings: settings,
            );
        }
      },
      theme: ThemeData(
        textSelectionHandleColor: Colors.grey,
        cursorColor: Colors.black,
        primaryColor: Colors.black,
        accentColor: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(0.0),
          labelStyle: TextStyle(fontSize: 18.0, color: Colors.black54),
        ),
      ),
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return FadeTransition(opacity: animation, child: child);
  }
}