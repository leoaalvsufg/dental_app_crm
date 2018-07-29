import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fteste/api/authentication_api.dart';
import 'package:fteste/components/buttons/button.dart';
import 'package:fteste/components/inputs/input_field.dart';
import 'package:fteste/models/user.dart';
import 'package:fteste/utils/validations.dart';
import 'package:fteste/views/home/index.dart';
import 'package:fteste/views/register/index.dart';

class LoginView extends StatefulWidget {
  static const String tag = '/login';

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _textSecondFocusNode = FocusNode();

  var _user = User();
  var _authApi = AuthenticationApi();
  var _validations = Validations();
  bool _autoValidate = false;
  bool _loading, _obscurePassword;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _obscurePassword = true;
  }

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
      _showInSnackBar(
          'Por favor, corrija os erros em vermelho antes de submiter.');
    } else {
      setState(() {
        _loading = true;
      });
      form.save();
      try {
        _authApi.login(_user).then((loginResult) {
          setState(() {
            _loading = false;
          });
          if (loginResult) {
            Navigator.pushNamed(context, HomeView.tag);
          } else {
            setState(() {
              _loading = false;
            });
            _showInSnackBar('Login ou senha inválidos');
          }
        }).catchError((Exception onError) {
          setState(() {
            _loading = false;
          });
          print('Error: $onError');
          _showInSnackBar('Aconteceu um erro no login. Tente novamente.');
        });
      } catch (e) {
        setState(() {
          _loading = false;
        });
        print('Error: $e');
        _showInSnackBar('Aconteceu um erro no login. Tente novamente.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final _logoWidget = Padding(
      padding: EdgeInsets.only(top: 100.0),
      child: FlutterLogo(size: 100.0,),
    );

    final _loginField = InputField(
      keyboardType: TextInputType.emailAddress,
      validatorCallback: _validations.validateEmail,
      labelText: 'E-mail',
      onSaveCallback: (String value) {
        _user.email = value;
      },
      onFieldSubmittedCallback: (String value) {
        FocusScope.of(context).requestFocus(_textSecondFocusNode);
      },
    );

    final _passwordField = InputField(
      validatorCallback: _validations.validatePassword,
      isObscureText: _obscurePassword,
      labelText: 'Senha',
      suffixIcon: IconButton(
        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.black26,),
        onPressed: _toggleObscurePassword,
      ),
      onSaveCallback: (String value) {
        _user.password = value;
        _textSecondFocusNode.unfocus();
      },
      focusNode: _textSecondFocusNode,
      onFieldSubmittedCallback: (String value) {
        _handleSubmitted();
      },
    );

    final _loginButton = Button(
      onPressed: _handleSubmitted,
      buttonName: 'ENTRAR',
      buttonColor: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      borderColor: Colors.transparent,
      borderWidth: 1.0,
    );

    final _registerButton = Button(
      onPressed: () => Navigator.pushNamed(context, RegisterView.tag),
      buttonName: 'REGISTRAR',
      width: MediaQuery.of(context).size.width,
      textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
      height: 50.0,
      borderColor: Colors.black54,
      borderWidth: 1.0,
    );

    final _loginContent = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _loginField,
        SizedBox(height: 10.0),
        _passwordField,
        SizedBox(height: 24.0),
        _loading ? CircularProgressIndicator() : _loginButton,
        SizedBox(height: 15.0),
        _loading ? Container() : _registerButton
      ],
    );

    final _loginForm =
        Form(key: _formKey, autovalidate: _autoValidate, child: _loginContent);

    return Scaffold(
        key: _scaffoldKey,
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: _logoWidget,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                    child: _loginForm, color: Theme.of(context).canvasColor),
              )
          ],
        )
      );
  }
}
