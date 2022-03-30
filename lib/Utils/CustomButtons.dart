import 'package:flutter/material.dart';

import 'Colors.dart';

class BackgroundImageButton extends StatelessWidget {
  const BackgroundImageButton({Key? key, this.onPress, this.title}) : super(key: key);
  final onPress;
  final title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/card_bg.png'),
            fit: BoxFit.fill,
          ),
          color: Color(0xff0F0F0F),
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: highLcolorLight,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class BorderRadiusButton extends StatelessWidget {
  BorderRadiusButton({Key? key, this.onPress, this.title}) : super(key: key);
  final onPress;
  final title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          color: Color(0xff0F0F0F),
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: highLcolorLight,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
