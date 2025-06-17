import 'package:driver_app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  Map<String, dynamic> driverInfo = {};
  Map<String, dynamic> carInfo = {};

  @override
  void initState() {
    super.initState();
    loadDriverData();
  }

  void loadDriverData() async {
    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);

    DatabaseEvent snapshot = await driverRef.once();

    if (snapshot.snapshot.value != null) {
      Map data = snapshot.snapshot.value as Map;

      setState(() {
        driverInfo = {
          "name": data["name"],
          "email": data["email"],
          "phone": data["phone"],
        };

        if (data["car_details"] != null) {
          carInfo = {
            "car_model": data["car_details"]["car_model"],
            "car_number": data["car_details"]["car_number"],
            "car_color": data["car_details"]["car_color"],
            "type": data["car_details"]["type"],
          };
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "الملف الشخصي للسائق",
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(child: Image.asset("images/logo1.png", height: 100)),
            const SizedBox(height: 30),
            buildInfoTile("الاسم", driverInfo["name"]),
            buildInfoTile("البريد الإلكتروني", driverInfo["email"]),
            buildInfoTile("رقم الهاتف", driverInfo["phone"]),
            const Divider(color: Colors.grey, thickness: 1, height: 32),
            buildInfoTile("موديل السيارة", carInfo["car_model"]),
            buildInfoTile("رقم السيارة", carInfo["car_number"]),
            buildInfoTile("لون السيارة", carInfo["car_color"]),
            buildInfoTile("نوع السيارة", carInfo["type"]),
          ],
        ),
      ),
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildInfoTile(String title, String? value) {
  //   return ListTile(
  //     title: Text(
  //       title,
  //       style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
  //     ),
  //     subtitle: Text(
  //       value ?? "Not Available",
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //   );
  // }
}
