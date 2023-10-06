import 'package:flutter/material.dart';

import '../../auth/firebase_auth.dart';

class LogoutButton extends StatelessWidget {
  final bool isEnglish;
  const LogoutButton({
    Key? key,
    required this.isEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0),
      child: ElevatedButton(
        onPressed: () async {
          logout(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontSize: 14),
        ),
        child: Text(
          isEnglish ? 'Logout' : 'لاگ آؤٹ',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
