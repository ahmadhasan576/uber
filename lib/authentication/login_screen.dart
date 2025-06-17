import 'package:driver_app/authentication/car_info_screen.dart';
import 'package:driver_app/authentication/signup_screen.dart';
import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:driver_app/global/global.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  void loginDriver() async {
    String email = emailTextEditingController.text.trim();
    String password = passwordTextEditingController.text.trim();

    if (!email.contains("@") || password.length < 6) {
      Fluttertoast.showToast(msg: "❌ Please enter valid credentials.");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      currentFirebaseUser = user;

      if (user != null) {
        // تحديث FCM Token
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          DatabaseReference driverRef = FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(user.uid);
          await driverRef.update({"deviceToken": token});
        }

        Fluttertoast.showToast(msg: "✅ Logged in successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => MySplashScreen()),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "❌ Login failed: ${e.toString().split(']').last.trim()}",
      );
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Column(
  //           children: [
  //             const SizedBox(height: 30),
  //             Padding(
  //               padding: EdgeInsets.all(20.0),
  //               child: Image.asset("images/logo1.png"),
  //             ),
  //             TextField(
  //               controller: emailTextEditingController,
  //               keyboardType: TextInputType.emailAddress,
  //               style: const TextStyle(color: Colors.grey),
  //               decoration: const InputDecoration(
  //                 labelText: "Email",
  //                 hintText: "Email",
  //                 enabledBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.grey),
  //                 ),
  //                 focusedBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.grey),
  //                 ),
  //                 hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
  //                 labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
  //               ),
  //             ),
  //             TextField(
  //               controller: passwordTextEditingController,
  //               obscureText: true,
  //               style: const TextStyle(color: Colors.grey),
  //               decoration: const InputDecoration(
  //                 labelText: "Password",
  //                 hintText: "Password",
  //                 enabledBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.grey),
  //                 ),
  //                 focusedBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.grey),
  //                 ),
  //                 hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
  //                 labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
  //               ),
  //             ),
  //             const SizedBox(height: 30),
  //             ElevatedButton(
  //               onPressed: loginDriver,
  //               style: ElevatedButton.styleFrom(
  //                 iconColor: Colors.lightGreenAccent,
  //               ),
  //               child: const Text(
  //                 "Login",
  //                 style: TextStyle(color: Colors.black54, fontSize: 18),
  //               ),
  //             ),
  //             TextButton(
  //               child: const Text(
  //                 "Do not have an account? Create Account",
  //                 style: TextStyle(color: Colors.grey),
  //               ),
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (c) => SignUpScreen()),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Center(child: Image.asset("images/logo1.png", height: 120)),
              const SizedBox(height: 40),
              Text(
                "مرحباً بك 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "قم بتسجيل الدخول إلى حساب السائق",
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Email Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "البريد الإلكتروني",
                    labelStyle: TextStyle(color: Colors.grey),
                    icon: Icon(Icons.email, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: passwordTextEditingController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "كلمة المرور",
                    labelStyle: TextStyle(color: Colors.grey),
                    icon: Icon(Icons.lock, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: loginDriver,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent[400],
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sign Up Prompt
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => SignUpScreen()),
                  );
                },
                child: const Text(
                  "ليس لديك حساب؟ أنشئ حساب جديد",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
