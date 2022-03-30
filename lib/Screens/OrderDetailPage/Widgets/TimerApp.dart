import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';

//ignore: must_be_immutable
class TimerApp extends StatefulWidget {
  TimerApp(this.isActive);
  var isActive = false;
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0;

  Timer? timer;

  void handleTick() {
    if (widget.isActive) {
      setState(() {
        secondsPassed = secondsPassed + 1;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.isActive = false;
  }

  @override
  Widget build(BuildContext context) {
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
    int seconds = secondsPassed % 60;
    int minutes = secondsPassed ~/ 60;
    int hours = secondsPassed ~/ (60 * 60);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          LabelText(label: 'HRS', value: hours.toString().padLeft(2, '0')),
          LabelText(label: 'MIN', value: minutes.toString().padLeft(2, '0')),
          LabelText(label: 'SEC', value: seconds.toString().padLeft(2, '0')),
        ],
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  LabelText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: highLcolor,
        image: DecorationImage(
          image: AssetImage('assets/card_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
