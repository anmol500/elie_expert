import 'dart:async';
import 'package:elie_expert/Database/API.dart';
import 'package:elie_expert/Database/Expert.dart';
import 'package:elie_expert/Database/Locator.dart';
import 'package:elie_expert/Screens/Home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  TextEditingController expertPhone = TextEditingController();
  TextEditingController expertPass = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    expertPhone.dispose();
    expertPass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(top: -height * .15, right: -MediaQuery.of(context).size.width * .4, child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(text: 'D', style: TextStyle(color: Color(0xffe46b10), fontSize: 30), children: [
        TextSpan(
          text: 'r E',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        TextSpan(
          text: 'lie  ',
          style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
        ),
      ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Expert Phone Number", "Phone No.", expertPhone),
        _entryField("Expert Password", "Password", expertPass),
      ],
    );
  }

  Widget _entryField(String title, String hint, controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(border: InputBorder.none, hintText: hint, fillColor: Color(0xfff3f3f4), filled: true),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return RoundedLoadingButton(
      color: Color(0xffee912e),
      successColor: Color(0xff735b8b),
      child: Text('Login', style: TextStyle(color: Colors.white)),
      controller: _btnController,
      onPressed: doLogin,
    );
  }

  doLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      Experts? ref = await API().getExpertByPhone(int.parse(expertPhone.text));

      if (ref != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int userPhone = int.parse(expertPhone.text);
        prefs.setInt("userPhone", userPhone);
        prefs.setString("userPass", expertPass.text);

        prefs.setString("userName", '');
        prefs.setString("userEmail", '');
        getItUserIn.setUserIn(prefs.get("userPhone"), prefs.get("userPass"), prefs.get("userName"), prefs.get('userEmail'));

        print(prefs.get("userName"));
        Timer(Duration(milliseconds: 1000), () {
          _btnController.success();
          Timer(Duration(milliseconds: 500), () {
            Navigator.pop(context);
            Navigator.push((context), MaterialPageRoute(builder: (context) => HomePage()));
          });
        });
      } else {
        Timer(Duration(milliseconds: 500), () {
          _btnController.error();
          Timer(Duration(milliseconds: 500), () {
            _btnController.reset();
          });
        });
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "You are not registered",
          ),
        );
      }
    } catch (e) {
      print(e);
      Timer(Duration(milliseconds: 100), () {
        _btnController.error();
        Timer(Duration(milliseconds: 500), () {
          _btnController.reset();
        });
      });
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          backgroundColor: Colors.red,
          message: "Please Enter Correct Password",
        ),
      );
    }
  }
}
// Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.symmetric(vertical: 15),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//                 color: Colors.grey.shade200,
//                 offset: Offset(2, 4),
//                 blurRadius: 5,
//                 spreadRadius: 2)
//           ],
//           gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: [Color(0xfffbb448), Color(0xfff7892b)])),
//       child: Text(
//         'Login',
//         style: TextStyle(fontSize: 20, color: Colors.white),
//       ),
//     );
