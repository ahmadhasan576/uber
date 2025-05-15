import 'package:driver_app/global/global.dart';
import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarInfoScreen extends StatefulWidget {
  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController CarModelTextEditingController = TextEditingController();
  TextEditingController CarNumberTextEditingController =
      TextEditingController();
  TextEditingController CarColorTextEditingController = TextEditingController();
  List<String> carTypeList = ["uber-x", "uber-go"];
  String? selectedCarType;
  saveCarInfo() {
    Map<String, dynamic> driverCarInfoMap = {
      "car_color": CarColorTextEditingController.text.trim(),
      "car_number": CarNumberTextEditingController.text.trim(),
      "car_model": CarModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };

    // DatabaseReference driverRef = FirebaseDatabase.instance.ref().child(
    //   "drivers",
    // );
    // driverRef
    //     .child(currentFirebaseUser!.uid)
    //     .child("car_details")
    //     .set(driverCarInfoMap);
    DatabaseReference driverRef = FirebaseDatabase.instance.ref().child(
      "drivers",
    );
    driverRef
        .child(currentFirebaseUser!.uid)
        .child("car_details")
        .set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Car Details Saved Successfully!");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => const MySplashScreen()),
    );
  }

  // saveCarInfo() {
  //   Map driverCarInfoMap = {
  //     "car_color": CarColorTextEditingController.text.trim(),
  //     "car_number": CarNumberTextEditingController.text.trim(),
  //     "car_model": CarModelTextEditingController.text.trim(),
  //     "type": selectedCarType,
  //   };

  //   DatabaseReference driverRef = FirebaseDatabase.instance.ref().child(
  //     "drivers",
  //   );
  //   driverRef
  //       .child(currentFirebaseUser!.uid)
  //       .child("car_details")
  //       .set(driverCarInfoMap);
  //   Fluttertoast.showToast(msg: "Car Details has been Saved, Congratulation ");
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (c) => const MySplashScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset("images/logo1.png"),
              ),

              const SizedBox(height: 10),

              const Text(
                "Write Car Details",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                controller: CarModelTextEditingController,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Car Model",
                  hintText: "Car Model",
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
                controller: CarNumberTextEditingController,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Car Number",
                  hintText: "Car Number",
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
                controller: CarColorTextEditingController,

                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  labelText: "Car Color",
                  hintText: "Car Color",
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
              const SizedBox(height: 20),
              DropdownButton(
                dropdownColor: Colors.white24,
                iconSize: 24,
                hint: const Text(
                  "Please Choose Car Type",
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                value: selectedCarType,
                onChanged: (newValue) {
                  setState(() {
                    selectedCarType = newValue.toString();
                  });
                },
                items:
                    carTypeList.map((car) {
                      return DropdownMenuItem(
                        child: Text(
                          car,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        value: car,
                      );
                    }).toList(),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (CarColorTextEditingController.text.isNotEmpty &&
                      CarNumberTextEditingController.text.isNotEmpty &&
                      CarModelTextEditingController.text.isNotEmpty &&
                      selectedCarType != null) {
                    saveCarInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "save Now",
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
