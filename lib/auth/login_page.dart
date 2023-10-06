import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/language_controller.dart';
import 'admin_login.dart';
import 'firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final languageController = Get.put(LanguageController());
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _maxPhoneNumberLength = 0.obs;
  final _formKey = GlobalKey<FormState>();

  LoginPage({Key? key}) : super(key: key);

  bool get isEnglish => languageController.isEnglish;

  void verifyPhoneNumber() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String phoneNumber = '+923${_phoneController.text}';

      signInWithPhone(Get.context!, name, phoneNumber);
    }
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    Text(
                      isEnglish ? 'Enter your Name' : 'اپنا نام درج کریں',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      validator: (value) {
                        if (value!.length < 3) {
                          return 'Name is too short';
                        }
                        return null; // Validation passed
                      },

                      cursorColor: Colors.green,
                      controller: _nameController,
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
                        labelText: isEnglish ? 'Name' : 'نام',
                        labelStyle: const TextStyle(color: Colors.green),
                      ),

                      style: const TextStyle(
                          color: Colors.black), // Set cursor color to green
                    ),
                    Text(
                      isEnglish
                          ? 'Enter your phone number'
                          : 'اپنا موبائل نمبر درج کریں',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      cursorColor: Colors.green,
                      controller: _phoneController,
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
                        labelText: isEnglish ? 'Phone Number' : 'موبائل نمبر',
                        labelStyle: const TextStyle(color: Colors.green),
                        prefix: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+92 - 3 ',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
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
                  ],
                ),
                Obx(() => ElevatedButton(
                      onPressed: _maxPhoneNumberLength.value == 9
                          ? verifyPhoneNumber
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _maxPhoneNumberLength.value == 9
                            ? Colors.green.withOpacity(1.0)
                            : Colors.green.withOpacity(0.5),
                      ),
                      child:
                          Text(isEnglish ? 'Login/Signup' : 'لاگ ان/سائن اپ'),
                    )),
                const SizedBox(
                  height: 100,
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      Get.to(AdminLogin());
                    },
                    style: ElevatedButton.styleFrom(
                        splashFactory: null,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.transparent),
                    child: Text(
                      isEnglish ? 'Login as admin' : 'لاگ ان ایڈمن',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
