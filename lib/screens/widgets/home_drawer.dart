import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/login_page.dart';
import '../../controller/language_controller.dart';
import '../HomeScreen.dart';
import '../../utils/logout_button.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.widget,
    required this.languageController,
  });

  final HomeScreen widget;

  final LanguageController languageController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 90,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name.isNotEmpty
                            ? widget.name
                            : languageController.isEnglish
                                ? 'Welcome Guest User!'
                                : 'خوش آمدید، مہمان صارف',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      widget.location.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                widget.location,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => ToggleButtons(
                  isSelected: [
                    languageController.isEnglish,
                    !languageController.isEnglish,
                  ],
                  onPressed: (index) {
                    if (index == 0 && languageController.isEnglish ||
                        index == 1 && !languageController.isEnglish) {
                      // Button is already selected, do nothing
                      return;
                    }

                    languageController.toggleLanguage();
                  },
                  selectedColor: Colors.white,
                  disabledColor: Colors.black,
                  fillColor: Colors.green,
                  borderColor: Colors.green,
                  selectedBorderColor: Colors.green,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'اردو',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 400,
              ),
              widget.phoneNumber.isNotEmpty
                  ? LogoutButton(isEnglish: languageController.isEnglish)
                  : ElevatedButton(
                      onPressed: () {
                        Get.to(LoginPage());
                      },
                      style: ElevatedButton.styleFrom(
                          splashFactory: null,
                          elevation: 0,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.transparent),
                      child: Text(
                        languageController.isEnglish ? 'Login' : 'لاگ ان کریں',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
