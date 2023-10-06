// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../utils/language_controller.dart';
import 'firebase_auth.dart';

// ignore: must_be_immutable
class OTPScreen extends StatelessWidget {
  final languageController = Get.find<LanguageController>();
  bool get isEnglish => languageController.isEnglish;
  String phoneNumber;
  String name;
  String verificationId;
  OTPScreen({
    Key? key,
    required this.phoneNumber,
    required this.name,
    required this.verificationId,
  }) : super(key: key);

  void verify(String verificationCode) {
    verifyOTP(
        phoneNumber: phoneNumber,
        name: name,
        context: Get.context!,
        verificationId: verificationId,
        userOTP: verificationCode,
        isEnglish: isEnglish);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          isEnglish ? "Verifying your number" : "آپکے نمبر کی تصدیق",
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            Text(
              isEnglish
                  ? "We have sent an sms with a code."
                  : "ہم نے آپ کو ایک کوڈ کے ساتھ ایک ایس ایم ایس بھیجا ہے۔",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            OtpTextField(
              numberOfFields: 6,
              textStyle: const TextStyle(color: Colors.black),
              borderColor: const Color(0xFF9CE86C),
              focusedBorderColor: const Color(0xFF9CE86C),
              cursorColor: Colors.black,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                verify(verificationCode);
              }, // end onSubmit
            ),
          ],
        ),
      ),
    );
  }
}
