// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:groce_ease/screens/HomeScreen.dart';
import 'package:groce_ease/auth/login_page.dart';
import 'package:groce_ease/controller/language_controller.dart';
import 'package:groce_ease/utils/service_area.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_screen.dart';

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
                      onPressed: () async {
                        // Request location permission
                        PermissionStatus status =
                            await Permission.location.request();

                        if (status.isGranted) {
                          // Permission granted, fetch user location
                          Position position =
                              await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high,
                          );

                          // Perform service area validation
                          bool isServiceArea = checkServiceArea(
                              position.latitude, position.longitude);

                          if (isServiceArea) {
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                              position.latitude,
                              position.longitude,
                            );

                            String address = '';
                            if (placemarks.isNotEmpty) {
                              Placemark placemark = placemarks.first;
                              String street = placemark.street ?? '';
                              String city = placemark.administrativeArea ?? '';

                              address = '$street, $city';
                            }
                            final sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString('location', address);
                            // Navigate to home screen
                            Get.to(HomeScreen(
                              name: '',
                              phoneNumber: "",
                              isEnglish: languageController.isEnglish,
                              location: address,
                            ));
                          } else {
                            // Show pop-up if user is not in service area
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(languageController.isEnglish
                                    ? 'Service Not Available'
                                    : 'سروس دستیاب نہیں'),
                                content: Text(languageController.isEnglish
                                    ? 'Sorry, the service is not available in your area.'
                                    : 'معاف کیجئے، آپ کے علاقے میں خدمت دستیاب نہیں ہے۔'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else if (status.isDenied ||
                            status.isPermanentlyDenied) {
                          // Permission denied or permanently denied by the user
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Permission Required'),
                              content: const Text(
                                  'Please grant location permission to use this feature.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
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
                  onTap: () {
                    Get.to(const MapScreen());
                  },
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
