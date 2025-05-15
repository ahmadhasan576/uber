import 'package:driver_app/authentication/car_info_screen.dart';
import 'package:driver_app/authentication/signup_screen.dart';
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
          MaterialPageRoute(builder: (c) => CarInfoScreen()),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "❌ Login failed: ${e.toString().split(']').last.trim()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset("images/logo1.png"),
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                controller: passwordTextEditingController,
                obscureText: true,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: loginDriver,
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
              ),
              TextButton(
                child: const Text(
                  "Do not have an account? Create Account",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => SignUpScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:driver_app/Widgets/progress_dialog.dart';
// import 'package:driver_app/authentication/signup_screen.dart';
// import 'package:driver_app/global/global.dart';
// import 'package:driver_app/splashScreen/splash_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();

//   validateForm() {
//     if (!emailTextEditingController.text.contains("@")) {
//       Fluttertoast.showToast(msg: "Email is not valid.");
//     } else if (passwordTextEditingController.text.isEmpty) {
//       Fluttertoast.showToast(msg: "Password is required.");
//     } else {
//       loginDriverNow();
//     }
//   }

//   loginDriverNow() async {
//     // Show progress dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext c) {
//         return ProgressDialog(message: "Processing... Please wait...");
//       },
//     );

//     try {
//       final User? firebaseUser =
//           (await FirebaseAuth.instance.signInWithEmailAndPassword(
//             email: emailTextEditingController.text.trim(),
//             password: passwordTextEditingController.text.trim(),
//           )).user;

//       if (firebaseUser != null) {
//         currentFirebaseUser = firebaseUser;
//         Fluttertoast.showToast(msg: "Login successful.");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (c) => const MySplashScreen()),
//         );
//       } else {
//         Navigator.pop(context);
//         Fluttertoast.showToast(msg: "Error occurred during login.");
//       }
//     } on FirebaseAuthException catch (error) {
//       Navigator.pop(context); // Close the progress dialog

//       // Handle specific errors
//       switch (error.code) {
//         case "user-not-found":
//           Fluttertoast.showToast(
//             msg: "Account does not exist. Please sign up.",
//           );
//           break;
//         case "wrong-password":
//           Fluttertoast.showToast(msg: "Incorrect password. Please try again.");
//           break;
//         default:
//           Fluttertoast.showToast(msg: "Error: ${error.message}");
//       }
//     } catch (e) {
//       Navigator.pop(context); // Close the progress dialog
//       Fluttertoast.showToast(msg: "Error: ${e.toString()}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 30),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Image.asset("images/logo1.png"),
//               ),
//               TextField(
//                 controller: emailTextEditingController,
//                 keyboardType: TextInputType.emailAddress,
//                 style: const TextStyle(color: Colors.grey),
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   hintText: "Email",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
//                   labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ),
//               TextField(
//                 controller: passwordTextEditingController,
//                 keyboardType: TextInputType.text,
//                 obscureText: true,
//                 style: const TextStyle(color: Colors.grey),
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   hintText: "Password",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
//                   labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   validateForm();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.lightGreenAccent,
//                   foregroundColor: Colors.black54,
//                 ),
//                 child: const Text("Login", style: TextStyle(fontSize: 18)),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account?",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (c) => SignUpScreen()),
//                       );
//                     },
//                     child: Text(
//                       "Sign Up",
//                       style: TextStyle(color: Colors.lightGreenAccent),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
