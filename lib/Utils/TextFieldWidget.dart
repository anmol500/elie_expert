import 'package:flutter/material.dart';

import 'Colors.dart';

//ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    this.labelText,
    this.hintText,
    this.onPress,
    required this.controller,
    this.inputType,
    this.inputFormator,
    this.fill,
    this.fillColor,
    this.textColor,
    this.focusBorderColor,
    this.enableBorderColor,
  });
  final labelText;
  final hintText;
  final onPress;
  TextEditingController controller;
  final inputType;
  final inputFormator;
  final fill;
  final fillColor;
  final textColor;
  var focusBorderColor;
  var enableBorderColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: textColor, fontSize: 16),
      textCapitalization: TextCapitalization.characters,
      cursorColor: highLcolor,
      //for accepting numbers only
      keyboardType: inputType,
      inputFormatters: inputFormator,

      //onTap
      onTap: onPress,

      controller: controller,
      decoration: InputDecoration(
        filled: fill,
        fillColor: fillColor,
        labelText: labelText,
        labelStyle: TextStyle(color: highLcolorLight, fontSize: 16),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusBorderColor != null ? focusBorderColor : highLcolorDark, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(7.0))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: enableBorderColor != null ? enableBorderColor : highLcolorDark, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(7.0))),
        hintText: hintText,
        hintStyle: TextStyle(color: highLcolor, fontSize: 16),
      ),
    );
  }
}
