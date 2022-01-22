import 'dart:async';

import 'package:elie_expert/Screens/LoginPage/loginPage.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ListOfPages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.clear();
                Navigator.pop(context);
                Navigator.push((context), MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                gradient: LinearGradient(colors: [spAppOrange, Colors.pink], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          ),
          title: Text("Elie's Expert"),
        ),
        backgroundColor: whiteSmoke,
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Orders"),
              selectedColor: spAppOrange,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.event_available_outlined),
              title: Text("Availability"),
              selectedColor: spAppOrange,
            ),
            SalomonBottomBarItem(
              icon: Icon(
                Icons.contact_mail_outlined,
              ),
              title: Text("SOS"),
              selectedColor: spAppOrange,
            ),
          ],
        ),
        body: Container(
          child: pages.elementAt(currentIndex),
        ),
      ),
    );
  }
}
