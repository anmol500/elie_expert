import 'dart:async';

import 'package:dio/dio.dart';
import 'package:elie_expert/Database/API.dart';
import 'package:elie_expert/Database/Expert.dart';
import 'package:elie_expert/Database/Locator.dart';
import 'package:elie_expert/LoginRegis/NewPassword.dart';
import 'package:elie_expert/Screens/Home/HomePage.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:elie_expert/Utils/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomButtons.dart';
import 'Registration.dart';
import 'Widgets/CustomTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController pass = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RoundedLoadingButtonController btController = RoundedLoadingButtonController();
  bool btnLoad = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phone.dispose();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: midBlack,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo.jpg',
                height: 60,
                width: 104,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 200,
            ),
            customTextField('Experts Phone Number', TextInputType.number, phone),
            customTextField('Password', TextInputType.visiblePassword, pass),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BackgroundImageButton(
                btnLoad: btnLoad,
                title: 'Login',
                onPress: () {
                  btnLoad = true;
                  setState(() {});
                  doLogin();
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    print('pressed register');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Registeration(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(fontSize: 16, color: Color(0xDEB6A2).withOpacity(1), fontFamily: 'PTSans-Regular'),
                        ),
                        TextSpan(
                          text: ' Register',
                          style: TextStyle(
                              color: Color(0xDEB6A2).withOpacity(1), fontSize: 16, fontFamily: 'PTSans-Regular', fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    phone = TextEditingController();
                    otpController = TextEditingController();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Container(
                              color: midBlack,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Confirmation',
                                        style: TextStyle(letterSpacing: 2.0, color: Colors.white, fontSize: 25.0, fontFamily: 'PT'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Please enter your phone number',
                                            style: TextStyle(letterSpacing: 2.0, color: Colors.white, fontSize: 13.0, fontFamily: 'tex'),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: TextFieldWidget(
                                                  inputType: TextInputType.phone,
                                                  controller: phone,
                                                  hintText: "xxxxx-xxxxx",
                                                  labelText: "Phone Number",
                                                  fill: true,
                                                  fillColor: Color(0xff707070),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  height: 53.0,
                                                  width: 53.0,
                                                  child: OutlinedButton(
                                                    style: OutlinedButton.styleFrom(
                                                      backgroundColor: Color(0xff141414),
                                                      side: BorderSide(
                                                        color: highLcolor,
                                                        width: 1.0,
                                                      ),
                                                      primary: highLcolor,
                                                    ),
                                                    onPressed: () async {
                                                      otpController.text = '';
                                                      Experts? ref = await API().getExpertByPhone(int.parse(phone.text));
                                                      print(ref);
                                                      if (ref == null) {
                                                        showTopSnackBar(
                                                          context,
                                                          CustomSnackBar.error(
                                                            backgroundColor: highLcolorDark,
                                                            message: "Your Phone No. Is Not Registered",
                                                          ),
                                                        );
                                                      } else {
                                                        await Dio().post('$baseUrl/generate_otp/${phone.text}');
                                                        showTopSnackBar(
                                                          context,
                                                          CustomSnackBar.success(
                                                            backgroundColor: highLcolor,
                                                            message: "We have sent your OTP at ${phone.text}",
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Text(
                                                        'Get OTP',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(letterSpacing: 2.0, color: Colors.white, fontSize: 15.0, fontFamily: 'tex'),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            'Enter OTP',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(letterSpacing: 2.0, color: Colors.white, fontSize: 13.0, fontFamily: 'tex'),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 400.0,
                                          child: PinCodeTextField(
                                            length: 6,
                                            obscureText: false,
                                            controller: otpController,
                                            animationType: AnimationType.scale,
                                            pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.circle,
                                                borderRadius: BorderRadius.circular(5.0),
                                                fieldHeight: 50.0,
                                                fieldWidth: 40.0,
                                                activeFillColor: highLcolor,
                                                selectedFillColor: Colors.white.withOpacity(0.4),
                                                selectedColor: Colors.white.withOpacity(0.3),
                                                activeColor: Color.fromRGBO(208, 85, 85, 0.5799999833106995),
                                                inactiveColor: Color.fromRGBO(208, 85, 85, 0.5799999833106995),
                                                inactiveFillColor: Colors.white.withOpacity(0.0)),
                                            animationDuration: Duration(milliseconds: 300),
                                            enableActiveFill: true,
                                            onCompleted: (v) {},
                                            beforeTextPaste: (text) {
                                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                              return false;
                                            },
                                            onChanged: (String value) {},
                                            appContext: context,
                                          ),
                                        ),
                                        RoundedLoadingButton(
                                          borderRadius: 12.0,
                                          color: highLcolor,
                                          width: 70,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 9,
                                              vertical: 10.0,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Reset',
                                                style: TextStyle(letterSpacing: 2.0, color: Colors.black, fontSize: 16, fontFamily: 'tex'),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            btController.start();
                                            ///////////////////AT HOME-GETTING LOCATION///////////////////AT HOME-GETTING LOCATION///////////////////AT HOME-GETTING LOCATION///////////////////AT HOME GETTING LOCATION
                                            if (otpController.text.length == 6) {
                                              print(otpController.text);
                                              try {
                                                var otpVer = (await Dio()
                                                        .get('$baseUrl/verify_customer/${phone.text}', queryParameters: {"otp": otpController.text}))
                                                    .data;

                                                if (otpVer) {
                                                  Navigator.push((context), MaterialPageRoute(builder: (context) => NewPassword()));
                                                  Navigator.pop(context);
                                                  Timer(Duration(milliseconds: 500), () {
                                                    btController.success();

                                                    Timer(Duration(milliseconds: 1000), () {
                                                      btController.reset();
                                                    });
                                                  });

                                                  Navigator.push((context), MaterialPageRoute(builder: (context) => NewPassword()));
                                                }
                                              } catch (e) {
                                                Timer(Duration(milliseconds: 500), () {
                                                  btController.error();
                                                  Timer(Duration(milliseconds: 1000), () {
                                                    btController.reset();
                                                  });
                                                });
                                                print(e);
                                                showTopSnackBar(
                                                  context,
                                                  CustomSnackBar.error(
                                                    backgroundColor: Colors.red,
                                                    message: "Please Enter Correct OTP",
                                                  ),
                                                );
                                              }
                                            } else {
                                              Timer(Duration(milliseconds: 500), () {
                                                btController.error();
                                                Timer(Duration(milliseconds: 1000), () {
                                                  btController.reset();
                                                });
                                              });
                                            }
                                          },
                                          controller: btController,
                                        ),
                                        SizedBox(
                                          height: 25.0,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Forget Password?',
                          style: TextStyle(fontSize: 16, color: Color(0xDEB6A2).withOpacity(1), fontFamily: 'PTSans-Regular'),
                        ),
                        TextSpan(
                          text: ' Click Here',
                          style: TextStyle(
                              color: Color(0xDEB6A2).withOpacity(1), fontSize: 16, fontFamily: 'PTSans-Regular', fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextButton(
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(color: highLcolor, fontSize: 16),
                ),
                onPressed: () async {
                  await launchUrl(Uri.parse('https://elie.world/Policy'));
                },
              ),
            ),
          ],
        ));
  }

  doLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      Experts? ref = await API().getExpertByPhone(int.parse(phone.text));
      print(ref.toString() + '3333');
      if (ref != null) {
        if (ref.password == pass.text) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              backgroundColor: Colors.green,
              message: "just A Moment",
            ),
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int userPhone = int.parse(phone.text);
          prefs.setInt("userPhone", userPhone);
          prefs.setString("userPass", pass.text);

          prefs.setString("userName", '');
          prefs.setString("userEmail", '');
          getItUserIn.setUserIn(prefs.get("userPhone"), prefs.get("userPass"), prefs.get("userName"), prefs.get('userEmail'));

          print(prefs.get("userName"));
          Timer(Duration(milliseconds: 1000), () {
            Timer(Duration(milliseconds: 500), () {
              Navigator.pop(context);
              Navigator.push((context), MaterialPageRoute(builder: (context) => HomePage()));
            });
          });
        } else {
          btnLoad = false;
          setState(() {});
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              backgroundColor: Colors.red,
              message: "Incorrect Password",
            ),
          );
        }
      } else {
        btnLoad = false;
        setState(() {});

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
      btnLoad = false;
      setState(() {});

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
