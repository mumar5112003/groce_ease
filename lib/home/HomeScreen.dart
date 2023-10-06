import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groce_ease/home/widgets/home_drawer.dart';
import 'package:groce_ease/home/widgets/home_future_builder.dart';

import 'package:groce_ease/utils/language_controller.dart';

import '../models/product_model.dart';
import 'CartScreen.dart';

class HomeScreen extends StatefulWidget {
  String phoneNumber;
  String name;
  String location;
  bool isEnglish;

  HomeScreen({
    Key? key,
    required this.phoneNumber,
    required this.name,
    required this.location,
    required this.isEnglish,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _refreshProducts() async {
    try {
      // Fetch the latest products from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();

      // Map the retrieved documents to Product objects
      List<Product> productList = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Update the state with the latest products
      setState(() {
        productList = productList;
      });

      // Show a success message or perform other actions
    } catch (error) {
      // Handle error
      print('Error refreshing products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageController =
        Get.put(LanguageController.fromHome(widget.isEnglish));

    return Obx(
      () => Scaffold(
        drawer:
            HomeDrawer(widget: widget, languageController: languageController),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Get.to(CartScreen(
                  isEnglish: languageController.isEnglish,
                ));
              },
            )
          ],
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
        body: RefreshIndicator(
          color: Colors.green,
          onRefresh: () async {
            _refreshProducts();
          },
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width * .9,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              'assets/groceries.png',
                              width: MediaQuery.of(context).size.width * .7,
                              height: MediaQuery.of(context).size.width * .3,
                            ),
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
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.green),
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
                              languageController.isEnglish
                                  ? 'View All'
                                  : 'سب دیکھیں',
                              style: const TextStyle(color: Colors.green),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    HomeFutureBuilder(languageController: languageController),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
