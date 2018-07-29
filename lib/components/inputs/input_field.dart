import 'package:flutter/material.dart';

typedef String ValidatorCallback(String value);
typedef void OnSaveCallback(String value);
typedef void OnFieldSubmittedCallback(String value);

class InputField extends StatelessWidget {

  final String labelText;
  final String helperText;
  final bool isAutoFocus;
  final TextInputType keyboardType;
  final bool isObscureText;
  final Widget suffixIcon;
  final FocusNode focusNode;
  final TextEditingController controller;
  final ValidatorCallback validatorCallback;
  final OnSaveCallback onSaveCallback;
  final OnFieldSubmittedCallback onFieldSubmittedCallback;

  InputField({this.isAutoFocus = false, this.labelText = '',
    this.helperText = '', this.isObscureText = false,
    this.suffixIcon, this.focusNode, this.controller,
    this.keyboardType = TextInputType.text, this.validatorCallback,
    this.onSaveCallback, this.onFieldSubmittedCallback});

  @override
  Widget build(BuildContext context) => TextFormField(
    keyboardType: keyboardType,
    autofocus: isAutoFocus,
    validator: validatorCallback,
    obscureText: isObscureText,
    decoration: InputDecoration(
      labelText: labelText,
      helperText: helperText,
      suffixIcon: suffixIcon
    ),
    style: TextStyle(fontSize: 22.0, color: Colors.black87),
    onSaved: onSaveCallback,
    onFieldSubmitted: onFieldSubmittedCallback,
    focusNode: focusNode,
    controller: controller
  );
}