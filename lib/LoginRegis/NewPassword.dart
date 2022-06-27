import 'package:dio/dio.dart';
import 'package:elie_expert/LoginRegis/login.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';

import 'CustomButtons.dart';
import 'Widgets/CustomTextField.dart';

// ignore: must_be_immutable
class NewPassword extends StatelessWidget {
  NewPassword({Key? key}) : super(key: key);

  TextEditingController phone = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: midBlack,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset(
            'assets/logo.jpg',
            height: 50,
            width: 134,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            customTextField('Phone Number', TextInputType.phone, phone),
            customTextField('Password', TextInputType.visiblePassword, pass),
            customTextField('Confirm Password', TextInputType.visiblePassword, cpass),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BorderRadiusButton(
                title: 'Reset Password',
                onPress: () async {
                  await Dio().put('$baseUrl/update_expert', data: {
                    'phone': int.parse(phone.text),
                    "password": pass.text,
                  });

                  Navigator.pop(context);
                  Navigator.push((context), MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
