import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

// معالج إشعارات الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 رسالة في الخلفية: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBY3aBQoVmhsLU2n3D5xU-kdYsWxyxiYIg",
        authDomain: "uber-ola-and-indriver-cl-fecfa.firebaseapp.com",
        databaseURL:
            "https://uber-ola-and-indriver-cl-fecfa-default-rtdb.firebaseio.com",
        projectId: "uber-ola-and-indriver-cl-fecfa",
        storageBucket: "uber-ola-and-indriver-cl-fecfa.appspot.com",
        messagingSenderId: "659490985048",
        appId: "1:659490985048:web:501ad8d498ea32f4e2262d",
        measurementId: "G-DLC27W9G5V",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // FCM - التسجيل لمعالجة الإشعارات الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ابدأ التطبيق
  runApp(
    MyApp(
      child: MaterialApp(
        title: 'Driver App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MySplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );

  // تهيئة الإشعارات (يمكنك نقل هذا إلى SplashScreen إن أحببت)
  await initializeFCM();
}

class MyApp extends StatefulWidget {
  final Widget? child;
  MyApp({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child!);
  }
}

Future<void> initializeFCM() async {
  final messaging = FirebaseMessaging.instance;

  // طلب الإذن
  await messaging.requestPermission();

  // الحصول على التوكن
  String? token = await messaging.getToken(
    vapidKey:
        "BFb6y6nnIH5rdz4FCd4Pm-BCjkHsjUwXRa4_VCt5qMeuctjp_yhmA-A6SYYHkT7vWk6Auzz-19vXi0orLZNWQQk", // <-- انسخ المفتاح من Firebase Console
  );

  print("📲 توكن السائق: $token");

  // احفظ التوكن في قاعدة بيانات السائق (هنا فقط كمثال)
  // Replace this with your driver's ID logic
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && token != null) {
    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(user.uid);
    await driverRef.update({"deviceToken": token});
  }

  // استقبال إشعارات أثناء استخدام التطبيق
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🔔 إشعار مباشر: ${message.notification?.title}");
  });

  // عند فتح التطبيق من إشعار
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📬 فتح الإشعار: ${message.data}");
    // هنا يمكن توجيه السائق إلى تفاصيل الرحلة
  });
}
