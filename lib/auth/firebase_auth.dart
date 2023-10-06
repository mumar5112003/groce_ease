// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groce_ease/screens/admin/admin_screen.dart';
import 'package:groce_ease/screens/map_screen.dart';
import 'package:groce_ease/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/landing_screen.dart';
import '../controller/language_controller.dart';
import 'otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final languageController = Get.find<LanguageController>();
bool get isEnglish => languageController.isEnglish;

void signInWithPhone(
    BuildContext context, String name, String phoneNumber) async {
  final auth = FirebaseAuth.instance;

  try {
    // Show the loading indicator
    showLoadingIndicator(context);

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        hideLoadingIndicator(context);
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        hideLoadingIndicator(context);
        throw Exception(e.message);
      },
      codeSent: ((String verificationId, int? resendToken) async {
        hideLoadingIndicator(context);
        Get.to(OTPScreen(
          verificationId: verificationId,
          name: name,
          phoneNumber: phoneNumber,
        ));
      }),
      codeAutoRetrievalTimeout: (verificationId) => {},
    );
  } on FirebaseAuthException {
    hideLoadingIndicator(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEnglish ? 'Wrong Number' : 'غلط نمبر')),
    );
  }
}

void verifyOTP({
  required BuildContext context,
  required String verificationId,
  required String userOTP,
  required String name,
  required String phoneNumber,
  required bool isEnglish,
}) async {
  final auth = FirebaseAuth.instance;
  final sharedPreferences = await SharedPreferences.getInstance();
  final firestore = FirebaseFirestore.instance;

  try {
    // Show the loading indicator
    showLoadingIndicator(context);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: userOTP,
    );

    await auth.signInWithCredential(credential);
    var user = UserModel(
        name: name, phoneNumber: phoneNumber, uid: auth.currentUser!.uid);
    // Store data to Firestore
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(user.toMap());

    // Store data to SharedPreferences
    await sharedPreferences.setString('phoneNumber', phoneNumber);
    await sharedPreferences.setBool('isEnglish', isEnglish);
    await sharedPreferences.setString('name', name);

    hideLoadingIndicator(context);
    Get.to(MapScreen.fromAuth(phoneNumber: phoneNumber, name: name));
  } on FirebaseAuthException {
    hideLoadingIndicator(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEnglish ? 'Wrong OTP' : 'غلط ایوٹی پی')),
    );
  }
}

void logout(BuildContext context) async {
  final auth = FirebaseAuth.instance;
  final sharedPreferences = await SharedPreferences.getInstance();

  try {
    await auth.signOut();
    await sharedPreferences.clear();

    // Redirect to login or initial screen
    // Example:
    Get.offAll(LandingScreen());
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEnglish ? 'Logout failed' : 'فشل ہوگیا')),
    );
  }
}

void signInAdminWithEmailAndPassword(
    BuildContext context, String email, String password) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await sharedPreferences.setString('email', email);

    Get.offAll(AdminScreen(
      email: email,
    ));
    // Handle successful login here, such as navigating to the next screen
    // You can use Get.to() or Navigator.push() to navigate to the desired screen
  } catch (error) {
    // Handle login error here, such as displaying an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
    // You can use Get.snackbar() or showDialog() to display an error message
  }
}

void signOutAdmin() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  try {
    await FirebaseAuth.instance.signOut();
    await sharedPreferences.setString('email', '');
    Get.offAll(LandingScreen());
  // ignore: empty_catches
  } catch (error) {
  
  }
}

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    ),
  );
}

void hideLoadingIndicator(BuildContext context) {
  Navigator.pop(context);
}
