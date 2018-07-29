import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;

  final double height;
  final double width;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final Color buttonColor;
  final Color splashColor;
  final Color highlightColor;
  final TextStyle textStyle;

  final TextStyle _textStyle = const TextStyle(
    color: const Color(0XFFFFFFFF),
    fontSize: 16.0,
    fontWeight: FontWeight.bold
  );

  Button({
    this.buttonName,
    this.onPressed,
    this.radius,
    this.height,
    this.borderWidth,
    this.borderColor,
    this.width,
    this.buttonColor,
    this.splashColor,
    this.highlightColor,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {

    var borderSide = (borderWidth != null) ?
      new BorderSide(width: borderWidth, color: borderColor) :
      new BorderSide();

    return new RawMaterialButton(
      fillColor: buttonColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      child: new Text(buttonName, style: textStyle ?? _textStyle),
      onPressed: onPressed,
      shape: new RoundedRectangleBorder(
        borderRadius: radius != null ?
          new BorderRadius.all(new Radius.circular(radius)) :
          BorderRadius.zero,
        side: borderSide
      ),
      constraints: new BoxConstraints(minWidth: width, minHeight: height)
    );
  }
}