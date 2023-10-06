import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/admin/admin_screen.dart';
import 'firebase_options.dart';
import 'screens/landing_screen.dart';
import 'screens/HomeScreen.dart'; // Import the GroceryApp widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final sharedPreferences = await SharedPreferences.getInstance();
  final phoneNumber = sharedPreferences.getString('phoneNumber');
  final isEnglish = sharedPreferences.getBool('isEnglish');
  final location = sharedPreferences.getString('location');
  final name = sharedPreferences.getString('name');
  final email = sharedPreferences.getString('email');
  runApp(MyApp(
      phoneNumber: phoneNumber,
      email: email,
      isEnglish: isEnglish,
      location: location,
      name: name));
}

class MyApp extends StatelessWidget {
  final String? phoneNumber;
  final String? name;
  final String? email; // Add email field
  final bool? isEnglish;
  final String? location;

  const MyApp({
    Key? key,
    this.phoneNumber,
    this.name,
    this.email,
    this.isEnglish,
    this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: (phoneNumber != null && phoneNumber!.isNotEmpty) ||
              (location != null && location!.isNotEmpty)
          ? HomeScreen(
              name: name ?? '',
              phoneNumber: phoneNumber ?? '',
              isEnglish: isEnglish ?? true,
              location: location ?? '',
            )
          : (email != null && email!.isNotEmpty) // Check if email is not empty
              ? AdminScreen(
                  email: email!,
                ) // Render AdminScreen if email is not empty
              : LandingScreen(),
    );
  }
}
