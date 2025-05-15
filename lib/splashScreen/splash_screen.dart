import 'dart:async';

import 'package:driver_app/authentication/login_screen.dart';
import 'package:driver_app/authentication/signup_screen.dart';
import 'package:driver_app/mainScreens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/global/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        //send user to main screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => MainScreen()),
        );
      } else {
        //send user to main screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => LoginScreen()),
        );
      }
    });
  }

  @override
  // void @override
  void initState() {
    super.initState();
    startTimer();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logo1.png"),
            const SizedBox(height: 10),

            const Text(
              "Uber & indriver clone app",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
