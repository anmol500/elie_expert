import 'dart:async';

import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';

class BackgroundImageButton extends StatefulWidget {
  BackgroundImageButton({Key? key, this.onPress, this.title, this.btnLoad}) : super(key: key);
  final onPress;
  final title;
  final btnLoad;

  @override
  State<BackgroundImageButton> createState() => _BackgroundImageButtonState();
}

class _BackgroundImageButtonState extends State<BackgroundImageButton> {
  late Widget btnWidget;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    btnWidget = Container(
      height: 60,
      width: 70,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/card_bg.png'),
          fit: BoxFit.fill,
        ),
        color: Color(0xff0F0F0F),
        borderRadius: BorderRadius.all(Radius.circular(7)),
        border: Border.all(
          color: Color(0xDEB6A2).withOpacity(1),
        ),
      ),
      child: Center(
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          btnWidget = Container(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(
                color: highLcolor,
              ),
            ),
          );
          widget.onPress();
          setState(() {});
          print(1);
          Timer(Duration(seconds: 1), () {
            if (!widget.btnLoad) {
              btnWidget = Container(
                height: 60,
                width: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/card_bg.png'),
                    fit: BoxFit.fill,
                  ),
                  color: Color(0xff0F0F0F),
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  border: Border.all(
                    color: Color(0xDEB6A2).withOpacity(1),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              );
              setState(() {});
              print(2);
            }
          });
        },
        child: btnWidget);
  }
}

class BorderRadiusButton extends StatefulWidget {
  BorderRadiusButton({Key? key, this.onPress, this.title}) : super(key: key);
  final onPress;
  final title;

  @override
  State<BorderRadiusButton> createState() => _BorderRadiusButtonState();
}

class _BorderRadiusButtonState extends State<BorderRadiusButton> {
  late Widget btnWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    btnWidget = Container(
      height: 50,
      width: 120,
      decoration: BoxDecoration(
        color: Color(0xff0F0F0F),
        borderRadius: BorderRadius.all(Radius.circular(7)),
        border: Border.all(
          color: Color(0xDEB6A2).withOpacity(1),
        ),
      ),
      child: Center(
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        btnWidget = Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Color(0xff0F0F0F),
            borderRadius: BorderRadius.all(Radius.circular(7)),
            border: Border.all(
              color: Color(0xDEB6A2).withOpacity(1),
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: highLcolor,
            ),
          ),
        );
        await widget.onPress();

        print(1);
        Timer(Duration(seconds: 2), () {
          btnWidget = Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
              color: Color(0xff0F0F0F),
              borderRadius: BorderRadius.all(Radius.circular(7)),
              border: Border.all(
                color: Color(0xDEB6A2).withOpacity(1),
              ),
            ),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          );
          setState(() {});
          print(2);
        });
      },
      child: btnWidget,
    );
  }
}
