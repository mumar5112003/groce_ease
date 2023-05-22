// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController1 extends GetxController {
  final RxBool _isEnglish = true.obs;

  bool get isEnglish => _isEnglish.value;

  LanguageController1(bool initialIsEnglish) {
    _isEnglish.value = initialIsEnglish;
  }

  void toggleLanguage() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    _isEnglish.toggle();
    sharedPreferences.setBool('isEnglish', _isEnglish.value);
    // You can also store the updated language preference in shared preferences or any other storage mechanism here
  }
}

// ignore: must_be_immutable
class GroceryApp extends StatelessWidget {
  String phoneNumber;
  bool isEnglish;
  GroceryApp({
    Key? key,
    required this.phoneNumber,
    required this.isEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rating = 1;
    final languageController = Get.put(LanguageController1(isEnglish));
    return Obx(
      () => Scaffold(
        drawer: Drawer(
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
                      size: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      phoneNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            languageController.isEnglish ? "GroceEase" : "گروس ایز",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset('assets/groceries.png'),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        languageController.isEnglish
                            ? 'Fresh Products'
                            : 'تازہ مصنوعات',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: languageController.isEnglish
                          ? 'Search for products'
                          : 'مصنوعات کی تلاش کریں',
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      languageController.isEnglish
                          ? 'Popular Products'
                          : 'مقبول مصنوعات',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        languageController.isEnglish ? 'View All' : 'سب دیکھیں',
                        style: const TextStyle(color: Colors.green),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 300.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 200.0,
                      margin: const EdgeInsets.only(left: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 150.0,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                languageController.isEnglish
                                    ? 'Product ${index + 1}'
                                    : 'مصنوع ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  languageController.isEnglish
                                      ? 'Product Name ${index + 1}'
                                      : 'مصنوع کا نام ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  '\$${(index + 1) * 2}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) {
                                      if (index < rating.floor()) {
                                        return const Icon(Icons.star,
                                            color: Colors.yellow);
                                      } else if (index < rating.ceil()) {
                                        return const Icon(Icons.star_half,
                                            color: Colors.yellow);
                                      } else {
                                        return const Icon(Icons.star_border,
                                            color: Colors.yellow);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
