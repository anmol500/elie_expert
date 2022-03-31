import 'package:flutter/material.dart';

import 'Colors.dart';

//ignore: must_be_immutable
class TextFieldWidgetBottomLine extends StatelessWidget {
  TextFieldWidgetBottomLine({
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
    this.focus,
    this.mandatory = true,
    this.onChange,
  });
  final labelText;
  final hintText;
  final onPress;
  var mandatory;
  var focus;
  TextEditingController controller;
  final inputType;
  final inputFormator;
  final fill;
  final fillColor;
  final textColor;
  var focusBorderColor;
  var enableBorderColor;
  final onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (mandatory) {
            return 'Please fill this field';
          }
          return null;
        }
        return null;
      },
      focusNode: focus,
      style: TextStyle(color: textColor, fontSize: 16),
      textCapitalization: TextCapitalization.characters,
      cursorColor: highLcolor,
      //for accepting numbers only
      keyboardType: inputType,
      inputFormatters: inputFormator,
      onChanged: onChange,

      //onTap
      onTap: onPress,

      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Color(0xDEB6A2).withOpacity(1))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Color(0xDEB6A2).withOpacity(1)),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 18,
          color: Color(0xDEB6A2).withOpacity(1),
        ),
      ),
    );
  }
}
