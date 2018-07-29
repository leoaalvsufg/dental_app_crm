import 'dart:io';
import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fteste/components/inputs/input_field.dart';

import 'package:image_picker/image_picker.dart';

import 'package:fteste/api/authentication_api.dart';
import 'package:fteste/components/buttons/button.dart';
import 'package:fteste/models/user.dart';
import 'package:fteste/utils/validations.dart';

class RegisterView extends StatefulWidget {
  static const String tag = '/register';
  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();

  var _newUser = User();
  var _authApi = AuthenticationApi();
  bool _autoValidate = false;
  var _validations = Validations();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _cpfFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  Future<File> _imageFile;

   void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget _previewImage() => FutureBuilder<File>(
    future: _imageFile,
    builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.data != null) {
        return Container(
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(snapshot.data),
              fit: BoxFit.cover
            ),
            border: Border.all(color: Colors.black54, width: 4.0),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        );
      } else if (snapshot.error != null) {
        return FlatButton(
          onPressed: () => _onImageButtonPressed(ImageSource.camera),
          child: Text(
            'Erro ao obter a foto. Tente novamente.',
            textAlign: TextAlign.center,
          ),
        );
      } else {
        return FlatButton(
          onPressed: () => _onImageButtonPressed(ImageSource.camera),
          child: Text(
            'Tire uma foto para enviar.',
            textAlign: TextAlign.center,
          ),
        );
      }
    });

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(value))
    );
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
      showInSnackBar('Por favor, corrija os erros em vermelho antes de enviar.');
    } else {
      form.save();
      _authApi.register(_newUser).then((onValue) {
        print(onValue);
      }).catchError((PlatformException onError) {
        print(onError.message);
        showInSnackBar(onError.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 10.0),
          child: IconButton(
            icon: Icon(Icons.camera_alt, size: 30.0, color: Colors.black54),
            onPressed: () => _onImageButtonPressed(ImageSource.camera),
          ),
        )
      ],
      backgroundColor: Theme.of(context).canvasColor,
      titleSpacing: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: FlatButton(
              child: Text('CANCELAR', style: TextStyle(color: Colors.black45, fontSize: 13.0),),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text('REGISTRAR', style: TextStyle(color: Colors.black54)),
          ),
          SizedBox(width: 40.0,)
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    ),
    body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              _previewImage(),
              SizedBox(height: 15.0,),
              InputField(
                validatorCallback: _validations.validateName,
                labelText: 'Nome',
                helperText: 'Obrigatório',
                onSaveCallback: (String name) {
                  _newUser.name = name;
                },
                onFieldSubmittedCallback: (String value) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              SizedBox(height: 30.0,),
              InputField(
                validatorCallback: _validations.validateEmail,
                keyboardType: TextInputType.emailAddress,
                labelText: 'E-mail',
                helperText: 'Obrigatório',
                onSaveCallback: (String email) {
                  _newUser.email = email;
                },
                focusNode: _emailFocusNode,
                onFieldSubmittedCallback: (String value) {
                  FocusScope.of(context).requestFocus(_phoneFocusNode);
                },
              ),
              SizedBox(height: 30.0,),
              InputField(
                validatorCallback: _validations.validatePhone,
                keyboardType: TextInputType.phone,
                labelText: 'Telefone',
                onSaveCallback: (String phone) {
                  _newUser.phone = phone;
                },
                focusNode: _phoneFocusNode,
                onFieldSubmittedCallback: (String value) {
                  FocusScope.of(context).requestFocus(_cpfFocusNode);
                },
              ),
              SizedBox(height: 30.0,),
              InputField(
                validatorCallback: _validations.validateCpf,
                keyboardType: TextInputType.number,
                labelText: 'CPF',
                helperText: 'Obrigatório',
                onSaveCallback: (String cpf) {
                  _newUser.cpf = cpf;
                },
                focusNode: _cpfFocusNode,
                onFieldSubmittedCallback: (String value) {
                  FocusScope.of(context).requestFocus(_addressFocusNode);
                },
              ),
              SizedBox(height: 30.0,),
              InputField(
                validatorCallback: _validations.validateText,
                labelText: 'Endereço',
                onSaveCallback: (String address) {
                  _newUser.address = address;
                },
                focusNode: _addressFocusNode,
                onFieldSubmittedCallback: (String value) {
                  FocusScope.of(context).requestFocus(_cityFocusNode);
                },
              ),
              SizedBox(height: 10.0),
              InputField(
                validatorCallback: _validations.validateText,
                labelText: 'Cidade',
                onSaveCallback: (String city) {
                  _newUser.city = city;
                },
                focusNode: _cityFocusNode,
                onFieldSubmittedCallback: (String value) {
                  FocusScope.of(context).requestFocus(_stateFocusNode);
                },
              ),
              SizedBox(height: 10.0),
              InputField(
                validatorCallback: _validations.validateText,
                labelText: 'Estado',
                onSaveCallback: (String state) {
                  _newUser.state = state;
                },
                focusNode: _stateFocusNode,
                onFieldSubmittedCallback: (String value) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              SizedBox(height: 30.0,),
              InputField(
                validatorCallback: _validations.validatePassword,
                isObscureText: true,
                labelText: 'Senha',
                helperText: 'Obrigatório',
                onSaveCallback: (String password) {
                  _newUser.password = password;
                },
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                onFieldSubmittedCallback: (String value) {
                  FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                },
              ),
              SizedBox(height: 10.0),
              InputField(
                validatorCallback: (String value) =>
                  _validations.validateConfirmPassword(value, _passwordController.text),
                isObscureText: true,
                labelText: 'Confirme a Senha',
                focusNode: _confirmPasswordFocusNode,
                onFieldSubmittedCallback: (String value) {
                  _handleSubmitted();
                },
              ),
              SizedBox(height: 15.0,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Button(
                  onPressed: _handleSubmitted,
                  buttonName: 'ENVIAR',
                  buttonColor: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  borderColor: Colors.transparent,
                  borderWidth: 1.0,
                ),
              )
            ],
          ),
        ),
      ),
    )
  );
}
