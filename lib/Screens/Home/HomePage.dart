import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Center(
            child: Image.asset(
              'assets/logo.jpg',
              height: 60,
              width: 134,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          unselectedItemColor: Colors.white,
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Orders"),
              selectedColor: highLcolorLight,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.event_available_outlined),
              title: Text("Availability"),
              selectedColor: highLcolorLight,
            ),
            SalomonBottomBarItem(
              icon: Icon(
                Icons.contact_mail_outlined,
              ),
              title: Text("SOS"),
              selectedColor: highLcolorLight,
            ),
            SalomonBottomBarItem(
              icon: Icon(
                Icons.manage_accounts_outlined,
              ),
              title: Text("Profile"),
              selectedColor: highLcolorLight,
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
