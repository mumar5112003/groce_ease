// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groce_ease/screens/widgets/home_drawer.dart';
import 'package:groce_ease/screens/widgets/home_future_builder.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:groce_ease/controller/language_controller.dart';

import '../models/product_model.dart';
import 'CartScreen.dart';

class HomeScreen extends StatefulWidget {
 final  String phoneNumber;
 final  String name;
 final String location;
 final  bool isEnglish;

  const HomeScreen({
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
   GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageController =
        Get.put(LanguageController.fromHome(widget.isEnglish));
 
    return Obx(
      () => AddToCartAnimation(
          cartKey: cartKey, // Provide a GlobalKey to locate the cart icon.
  height: 30,        // Height of the product image.
  width: 30,         // Width of the product image.
  opacity: 0.85,     // Opacity of the product image.
  dragAnimation: const DragToCartAnimationOptions(
    rotation: true, // Enable rotation animation.
  ),
  jumpAnimation: const JumpAnimationOptions(),
  createAddToCartAnimation: (runAddToCartAnimation) {
    // Store the 'runAddToCartAnimation' function to trigger animations later.
    this.runAddToCartAnimation = runAddToCartAnimation;
  },

        child: Scaffold(
          drawer:
              HomeDrawer(widget: widget, languageController: languageController),
          appBar: AppBar(
            actions: [
              AddToCartIcon(
                key: cartKey,
                icon:  IconButton(onPressed: () => Get.to(CartScreen()),icon: const Icon(Icons.shopping_cart)),
                 badgeOptions: const BadgeOptions(
                active: true,
                backgroundColor: Colors.red,
              ),
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
                      HomeFutureBuilder(languageController: languageController,onClick: listClick,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
    void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!
        .runCartAnimation((++_cartQuantityItems).toString());
  }
}
