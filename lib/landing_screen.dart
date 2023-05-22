import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groce_ease/auth/login_page.dart';

class LanguageController extends GetxController {
  final RxBool _isEnglish = true.obs;

  bool get isEnglish => _isEnglish.value;

  void toggleLanguage() {
    _isEnglish.toggle();
  }
}

class LandingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildPage(languageController, context, true),
          buildPage(languageController, context, false),
        ],
      ),
    );
  }

  Widget buildPage(
    LanguageController languageController,
    BuildContext context,
    bool isEnglish,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Row(
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
                      if (index == 0) {
                        _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
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
                ElevatedButton(
                  onPressed: () {
                    Get.to(LoginPage());
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
                    isEnglish ? 'Login' : 'لاگ ان کریں',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Image.asset(
            'assets/cart.png',
            width: 200,
            height: 200,
          ),
          Center(
            child: Text(
              isEnglish ? 'Welcome to GroceEase' : 'گروس ایز میں خوش آمدید',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              isEnglish
                  ? "Welcome to our Grocery App! Discover a wide selection of fresh and high-quality groceries right at your fingertips. Enjoy hassle-free delivery straight to your doorstep and experience the convenience of online grocery shopping."
                  : "ہمارے گروسری ایپ میں خوش آمدید! تازہ اور اعلیٰ معیار کی گروسریزوں کی وسیع تشکیلیں آپ کے انگلیوں کے قریب۔ ڈیلیوری کا لطف اٹھائیں، اپنے دروازے تک بلا مسئلہ پہنچائیں اور آن لائن گروسری خریداری کی سہولت کا تجربہ کریں۔",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            isEnglish
                ? 'Select your delivery location'
                : 'اپنی ترسیل کی جگہ منتخب کریں',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: MediaQuery.of(context).size.height - 700,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add your logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: Text(
                        isEnglish
                            ? 'Use my current location'
                            : 'میری موجودہ جگہ استعمال کریں',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    isEnglish
                        ? 'Set location manually'
                        : 'دستیاب جگہ ترتیب دیں',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
