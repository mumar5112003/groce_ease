import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth.dart';
import '../landing_screen.dart';

class LoginPage extends StatelessWidget {
  final languageController = Get.find<LanguageController>();
  final TextEditingController _mobileController = TextEditingController();
  final _maxPhoneNumberLength = 0.obs;

  LoginPage({Key? key}) : super(key: key);

  bool get isEnglish => languageController.isEnglish;

  void verifyPhoneNumber() {
    String phoneNumber = '+923${_mobileController.text}';
    signInWithPhone(Get.context!, phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Lets get connected'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEnglish
                  ? 'Enter your mobile number'
                  : 'اپنا موبائل نمبر درج کریں',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              cursorColor: Colors.green,
              controller: _mobileController,
              maxLength: 9,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelText: isEnglish ? 'Mobile Number' : 'موبائل نمبر',
                labelStyle: const TextStyle(color: Colors.green),
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '+92 - 3 ',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                _maxPhoneNumberLength.value =
                    value.length >= 9 ? 9 : value.length;
              },
              style: const TextStyle(
                  color: Colors.black), // Set cursor color to green
            ),
            const SizedBox(height: 16.0),
            Obx(() => ElevatedButton(
                  onPressed: _maxPhoneNumberLength.value == 9
                      ? verifyPhoneNumber
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _maxPhoneNumberLength.value == 9
                        ? Colors.green.withOpacity(1.0)
                        : Colors.green.withOpacity(0.5),
                  ),
                  child: Text(isEnglish ? 'Login/Signup' : 'لاگ ان/سائن اپ'),
                )),
          ],
        ),
      ),
    );
  }
}
