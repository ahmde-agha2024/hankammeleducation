import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamssgazaa/pref/shared_pref_controller.dart';
import 'package:shamssgazaa/screens/auth_screens/login_screen.dart';
import 'package:shamssgazaa/screens/bottomNavigationBar.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      var route = SharedPrefController().loggedIn
          ? BottomNavigationScreen()
          : BottomNavigationScreen();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration:  BoxDecoration(
           color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 180,
                width: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'images/thumbnail_Logo.png',
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'حنكمـــل تعليـــم',
              style: GoogleFonts.cairo(color: Color(0xff118ab2),fontSize: 16,fontWeight: FontWeight.bold),
            ),

          ],
        ),
      )),
    );
  }
}
