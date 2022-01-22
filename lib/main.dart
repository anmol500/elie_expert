import 'package:elie_expert/Screens/LoginPage/loginPage.dart';
import 'package:elie_expert/Service/Location/ListenLocation.dart';
import 'package:elie_expert/Service/Location/LocationTracking.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Database/API.dart';
import 'Database/Locator.dart';
import 'Screens/Home/HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(MyApp());
  LocationTracking().listenLocation();
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
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: spAppOrange,
                ),
              ),
            )
          : mainScreen,
    );
  }
}
