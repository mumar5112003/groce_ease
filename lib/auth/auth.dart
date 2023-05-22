import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groce_ease/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../landing_screen.dart';
import 'otp_screen.dart';

final languageController = Get.find<LanguageController>();
bool get isEnglish => languageController.isEnglish;
void signInWithPhone(BuildContext context, String phoneNumber) async {
  final auth = FirebaseAuth.instance;

  try {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        throw Exception(e.message);
      },
      codeSent: ((String verificationId, int? resendToken) async {
        Get.to(OTPScreen(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
        ));
      }),
      codeAutoRetrievalTimeout: (verificationId) => {},
    );
  } on FirebaseAuthException {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEnglish ? 'Wrong Number' : 'غلط نمبر')));
  }
}

void verifyOTP(
    {required BuildContext context,
    required String verificationId,
    required String userOTP,
    required String phoneNumber,
    required bool isEnglish}) async {
  final auth = FirebaseAuth.instance;
  final sharedPreferences = await SharedPreferences.getInstance();

  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: userOTP,
    );

    await auth.signInWithCredential(credential);
    await sharedPreferences.setString('phoneNumber', phoneNumber);
    await sharedPreferences.setBool("isEnglish", isEnglish);
    Get.offAll(GroceryApp(
      phoneNumber: phoneNumber,
      isEnglish: isEnglish,
    ));
  } on FirebaseAuthException {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEnglish ? 'Wrong OTP' : 'غلط ایوٹی پی')));
  }
}
