import 'package:driver_app/global/global.dart';
import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

class ProfilTabPage extends StatefulWidget {
  const ProfilTabPage({super.key});

  @override
  State<ProfilTabPage> createState() => _ProfilTabPageState();
}

class _ProfilTabPageState extends State<ProfilTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("Sign Out"),
        onPressed: () {
          fAuth.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const MySplashScreen()),
          );
        },
      ),
    );
  }
}
