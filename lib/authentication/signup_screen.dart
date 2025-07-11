import 'package:driver_app/Widgets/progress_dialog.dart';
import 'package:driver_app/authentication/car_info_screen.dart';
import 'package:driver_app/authentication/login_screen.dart';
// import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:driver_app/global/global.dart';
import 'package:geolocator/geolocator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 characters.");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid.");
    } else if (phoneTextEditingController.text.length != 10) {
      Fluttertoast.showToast(msg: "Phone Number should be 10 nember.");
    } else if (passwordTextEditingController.text.length < 5) {
      Fluttertoast.showToast(
        msg: "Password is Wrong, should more than 5 charectar",
      );
    } else {
      saveDriverInfoNow();
    }
  }

  saveDriverInfoNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processing, please wait...");
      },
    );

    final User? firebaseUser =
        (await fAuth
            .createUserWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim(),
            )
            .catchError((msg) {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "error" + msg.toString());
            })).user;

    if (firebaseUser != null) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Map<String, dynamic> driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "latitude": position.latitude,
        "longitude": position.longitude,
      };

      DatabaseReference driverRef = FirebaseDatabase.instance.ref().child(
        "drivers",
      );
      driverRef.child(firebaseUser.uid).set(driverMap);

      // driverRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been created.");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (c) => CarInfoScreen()),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been created.");
    }
  }

  // saveDriverInfoNow() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext c) {
  //       return ProgressDialog(message: "Processing, please wait...");
  //     },
  //   );
  //   final User? firebaseUser =
  //       (await fAuth
  //           .createUserWithEmailAndPassword(
  //             email: emailTextEditingController.text.trim(),
  //             password: passwordTextEditingController.text.trim(),
  //           )
  //           .catchError((msg) {
  //             Navigator.pop(context);
  //             Fluttertoast.showToast(msg: "error" + msg.toString());
  //           })).user;

  //   if (firebaseUser != null) {
  //     // احصل على موقع المستخدم
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     Map<String, dynamic> driverMap = {
  //       "id": firebaseUser.uid,
  //       "name": nameTextEditingController.text.trim(),
  //       "email": emailTextEditingController.text.trim(),
  //       "phone": phoneTextEditingController.text.trim(),
  //       "latitude": position.latitude,
  //       "longitude": position.longitude,
  //     };
  //     DatabaseReference driverRef = FirebaseDatabase.instance.ref().child(
  //       "driver",
  //     );
  //     driverRef.child(firebaseUser.uid).set(driverMap);
  //     currentFirebaseUser = firebaseUser;
  //     Fluttertoast.showToast(msg: "Account has been created.");
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (c) => CarInfoScreen()),
  //     );
  //   } else {
  //     Navigator.pop(context);
  //     Fluttertoast.showToast(msg: "Account has been not created.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Center(child: Image.asset("images/logo1.png", height: 100)),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "تسجيل سائق جديد",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField("الاسم الكامل", nameTextEditingController),
              const SizedBox(height: 15),
              _buildTextField(
                "البريد الإلكتروني",
                emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                "رقم الهاتف",
                phoneTextEditingController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                "كلمة المرور",
                passwordTextEditingController,
                obscureText: true,
              ),
              const SizedBox(height: 30),

              // زر إنشاء الحساب
              ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "إنشاء الحساب الآن",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => LoginScreen()),
                  );
                },
                child: const Text(
                  "هل لديك حساب بالفعل؟ سجل الدخول من هنا",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromARGB(255, 30, 255, 0)),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           children: [
  //             const SizedBox(height: 20),
  //             Image.asset("images/logo1.png"),
  //             const SizedBox(height: 10),
  //             const Text(
  //               "Register as a Driver",
  //               style: TextStyle(
  //                 fontSize: 26,
  //                 color: Colors.grey,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             TextField(
  //               controller: nameTextEditingController,
  //               style: const TextStyle(color: Colors.grey),
  //               decoration: _inputDecoration("Name"),
  //             ),
  //             TextField(
  //               controller: emailTextEditingController,
  //               keyboardType: TextInputType.emailAddress,
  //               style: const TextStyle(color: Colors.grey),
  //               decoration: _inputDecoration("Email"),
  //             ),
  //             TextField(
  //               controller: phoneTextEditingController,
  //               keyboardType: TextInputType.phone,
  //               style: const TextStyle(color: Colors.grey),
  //               decoration: _inputDecoration("Phone"),
  //             ),
  //             TextField(
  //               controller: passwordTextEditingController,
  //               obscureText: true,
  //               style: const TextStyle(color: Colors.grey),
  //               decoration: _inputDecoration("Password"),
  //             ),
  //             const SizedBox(height: 20),

  //             ElevatedButton(
  //               onPressed: () {
  //                 validateForm();
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 iconColor: Colors.lightGreenAccent,
  //               ),
  //               child: const Text(
  //                 "Create Account Now",
  //                 style: TextStyle(color: Colors.black54, fontSize: 18),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (c) => LoginScreen()),
  //                 );
  //               },
  //               child: const Text(
  //                 "Already have an account? Login here",
  //                 style: TextStyle(color: Colors.grey),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    );
  }
}
