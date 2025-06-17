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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(24.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             const SizedBox(height: 40),
  //             Center(child: Image.asset("images/logo1.png", height: 100)),
  //             const SizedBox(height: 20),
  //             const Center(
  //               child: Text(
  //                 "Write Car Details",
  //                 style: TextStyle(
  //                   fontSize: 28,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   letterSpacing: 1.2,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 30),
  //             _buildTextField("Car Model", CarModelTextEditingController),
  //             const SizedBox(height: 15),
  //             _buildTextField("Car Number", CarNumberTextEditingController),
  //             const SizedBox(height: 15),
  //             _buildTextField("Car Color", CarColorTextEditingController),
  //             const SizedBox(height: 25),

  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 16,
  //                 vertical: 4,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.shade900,
  //                 borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(color: Colors.grey),
  //               ),
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButton<String>(
  //                   dropdownColor: Colors.grey.shade900,
  //                   hint: const Text(
  //                     "Please Choose Car Type",
  //                     style: TextStyle(color: Colors.grey, fontSize: 14),
  //                   ),
  //                   value: selectedCarType,
  //                   isExpanded: true,
  //                   icon: const Icon(
  //                     Icons.arrow_drop_down,
  //                     color: Colors.white,
  //                   ),
  //                   items:
  //                       carTypeList.map((car) {
  //                         return DropdownMenuItem(
  //                           value: car,
  //                           child: Text(
  //                             car,
  //                             style: const TextStyle(color: Colors.white),
  //                           ),
  //                         );
  //                       }).toList(),
  //                   onChanged: (newValue) {
  //                     setState(() {
  //                       selectedCarType = newValue;
  //                     });
  //                   },
  //                 ),
  //               ),
  //             ),

  //             const SizedBox(height: 30),
  //             ElevatedButton(
  //               onPressed: () {
  //                 if (CarColorTextEditingController.text.isNotEmpty &&
  //                     CarNumberTextEditingController.text.isNotEmpty &&
  //                     CarModelTextEditingController.text.isNotEmpty &&
  //                     selectedCarType != null) {
  //                   saveCarInfo();
  //                 }
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.lightGreenAccent[400],
  //                 padding: const EdgeInsets.symmetric(vertical: 16),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //               child: const Text(
  //                 "Save Now",
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
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
                  "أدخل تفاصيل السيارة",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField("موديل السيارة", CarModelTextEditingController),
              const SizedBox(height: 15),
              _buildTextField("رقم السيارة", CarNumberTextEditingController),
              const SizedBox(height: 15),
              _buildTextField("لون السيارة", CarColorTextEditingController),
              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.grey.shade900,
                    hint: const Text(
                      "يرجى اختيار نوع السيارة",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    value: selectedCarType,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    items:
                        carTypeList.map((car) {
                          return DropdownMenuItem(
                            value: car,
                            child: Text(
                              car,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCarType = newValue;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),
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
                  backgroundColor: Colors.lightGreenAccent[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "حفظ الآن",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
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
          borderSide: const BorderSide(color: Colors.lightGreenAccent),
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
  //         padding: const EdgeInsets.all(24.0),
  //         child: Column(
  //           children: [
  //             const SizedBox(height: 24),
  //             Padding(
  //               padding: EdgeInsets.all(20.0),
  //               child: Image.asset("images/logo1.png"),
  //             ),

  //             const SizedBox(height: 10),

  //             const Text(
  //               "Write Car Details",
  //               style: TextStyle(
  //                 fontSize: 26,
  //                 color: Colors.grey,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),

  //             TextField(
  //               controller: CarModelTextEditingController,
  //               style: const TextStyle(color: Colors.grey),
  //               decoration: const InputDecoration(
  //                 labelText: "Car Model",
  //                 hintText: "Car Model",
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
  //               controller: CarNumberTextEditingController,
  //               style: const TextStyle(color: Colors.grey),
  //               decoration: const InputDecoration(
  //                 labelText: "Car Number",
  //                 hintText: "Car Number",
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
  //               controller: CarColorTextEditingController,

  //               style: const TextStyle(color: Colors.grey),
  //               decoration: const InputDecoration(
  //                 labelText: "Car Color",
  //                 hintText: "Car Color",
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
  //             const SizedBox(height: 20),
  //             DropdownButton(
  //               dropdownColor: Colors.white24,
  //               iconSize: 24,
  //               hint: const Text(
  //                 "Please Choose Car Type",
  //                 style: TextStyle(fontSize: 14.0, color: Colors.grey),
  //               ),
  //               value: selectedCarType,
  //               onChanged: (newValue) {
  //                 setState(() {
  //                   selectedCarType = newValue.toString();
  //                 });
  //               },
  //               items:
  //                   carTypeList.map((car) {
  //                     return DropdownMenuItem(
  //                       child: Text(
  //                         car,
  //                         style: const TextStyle(color: Colors.grey),
  //                       ),
  //                       value: car,
  //                     );
  //                   }).toList(),
  //             ),

  //             const SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () {
  //                 if (CarColorTextEditingController.text.isNotEmpty &&
  //                     CarNumberTextEditingController.text.isNotEmpty &&
  //                     CarModelTextEditingController.text.isNotEmpty &&
  //                     selectedCarType != null) {
  //                   saveCarInfo();
  //                 }
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 iconColor: Colors.lightGreenAccent,
  //               ),
  //               child: const Text(
  //                 "save Now",
  //                 style: TextStyle(color: Colors.black54, fontSize: 18),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
