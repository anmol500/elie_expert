import 'dart:io';

import 'package:elie_expert/Service/Location/LocationTracking.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Database/Locator.dart';
import 'LoginRegis/login.dart';
import 'Screens/Home/HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
  LocationTracking().listenLocation();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget mainScreen = LoginPage();
  bool loading = true;
  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get("userPhone"));
    if (prefs.get("userPhone") != null && prefs.get("userPhone") != 'null') {
      print(prefs.get("userPhone"));
      await getItUserIn.setUserIn(prefs.get("userPhone"), prefs.get("userPass"), '', '');
      loading = false;
      mainScreen = HomePage();
      setState(() {});
    } else {
      print(prefs.get("userPhone").runtimeType);
      getItUserIn.setUserIn(prefs.get("userPhone"), prefs.get("userPass"), '', '');
      loading = false;
      mainScreen = LoginPage();
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getUserInfo();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loading
          ? SafeArea(
              child: Scaffold(
                backgroundColor: midBlack,
                body: Center(
                  child: CircularProgressIndicator(
                    color: highLcolor,
                  ),
                ),
              ),
            )
          : mainScreen,
    );
  }
}
