import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/language_controller.dart';
import 'firebase_auth.dart';

class AdminLogin extends StatelessWidget {
  final languageController = Get.put(LanguageController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AdminLogin({Key? key}) : super(key: key);

  bool get isEnglish => languageController.isEnglish;

  void login() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      signInAdminWithEmailAndPassword(Get.context!, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Admin Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 200),
                Text(
                  isEnglish ? 'Enter your Email' : 'اپنا ای میل درج کریں',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    }
                    return null; // Validation passed
                  },
                  cursorColor: Colors.green,
                  controller: _emailController,
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
                    labelText: isEnglish ? 'Email' : 'ای میل',
                    labelStyle: const TextStyle(color: Colors.green),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  isEnglish ? 'Enter your Password' : 'اپنا پاس ورڈ درج کریں',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    return null; // Validation passed
                  },
                  cursorColor: Colors.green,
                  controller: _passwordController,
                  obscureText: true,
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
                    labelText: isEnglish ? 'Password' : 'پاس ورڈ',
                    labelStyle: const TextStyle(color: Colors.green),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    isEnglish ? 'Login' : 'لاگ ان',
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
