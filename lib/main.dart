import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'landing_screen.dart';
import 'HomeScreen.dart'; // Import the GroceryApp widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final sharedPreferences = await SharedPreferences.getInstance();
  final phoneNumber = sharedPreferences.getString('phoneNumber');
  final isEnglish = sharedPreferences.getBool('isEnglish');
  runApp(MyApp(phoneNumber: phoneNumber, isEnglish: isEnglish));
}

class MyApp extends StatelessWidget {
  final String? phoneNumber;
  final bool? isEnglish;
  const MyApp({Key? key, this.phoneNumber, this.isEnglish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: phoneNumber != null
          ? GroceryApp(
              phoneNumber: phoneNumber!,
              isEnglish: isEnglish!,
            )
          : LandingScreen(),
    );
  }
}
