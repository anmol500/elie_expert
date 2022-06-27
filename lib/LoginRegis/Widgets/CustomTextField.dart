import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';

customTextField(title, type, cont, {ifsc = false, line = 1, mandate = false, onSuffixPress, visible = false}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
      validator: (value) {
        if ((value == null || value.isEmpty) && mandate == true) {
          return 'Please enter $title';
        }
        return null;
      },
      obscureText: type == TextInputType.visiblePassword && !visible ? true : false,
      maxLines: line,
      textCapitalization: ifsc ? TextCapitalization.characters : TextCapitalization.none,
      controller: cont,
      style: TextStyle(
        color: Color(0xDEB6A2).withOpacity(1),
      ),
      decoration: InputDecoration(
        suffixIcon: onSuffixPress != null
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  !visible ? Icons.visibility_off : Icons.visibility,
                  color: highLcolorLight,
                ),
                onPressed: () {
                  onSuffixPress();
                },
              )
            : null,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Color(0xDEB6A2).withOpacity(1))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Color(0xDEB6A2).withOpacity(1)),
        ),
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 18,
          color: Color(0xDEB6A2).withOpacity(1),
        ),
      ),
      keyboardType: type,
    ),
  );
}
