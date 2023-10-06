// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:groce_ease/controller/cart_controller.dart';
import 'package:groce_ease/models/cart_model.dart';

import '../../controller/language_controller.dart';
import '../../models/product_model.dart';

class HomeFutureBuilder extends StatelessWidget {
  final GlobalKey widgetKey = GlobalKey();
    
  final void Function(GlobalKey) onClick;
  
   HomeFutureBuilder({
    Key? key,
    
    required this.languageController, required this.onClick,
  }) : super(key: key);

  final LanguageController languageController;
 
  @override
  Widget build(BuildContext context) {
 
    final cartController=Get.put(CartController());
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('products').get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error fetching products');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          final List<Product> productList = snapshot.data!.docs
              .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          return SizedBox(
            height: 300.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                 final doc = snapshot.data!.docs[index]; // Access the document snapshot
    final productId = doc.id; 
                final product = productList[index];
                return AppListItem(index: index,product: product, productId: productId, cartController: cartController, onClick: onClick, languageController: languageController);
              },
            ),
          );
        });
  }
}

class AppListItem extends StatelessWidget {
    final GlobalKey widgetKey = GlobalKey();
  final int index;
  final void Function(GlobalKey) onClick;
   AppListItem({
    super.key,
    required this.product,
    required this.productId,
    required this.cartController,
    required this.onClick,
    required this.languageController, required this.index,
  });

  final Product product;
  final String productId;
  final CartController cartController;

  final LanguageController languageController;

  @override
  Widget build(BuildContext context) {
        Container mandatoryContainer = Container(
      key: widgetKey,
      color: Colors.transparent,
      child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    Colors.green),
                          ),
                        );
                      }
                    },
                  ),
    );
    return Container(
      width: 200.0,
      margin: const EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 4),
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
              color: Colors.white,
            ),
            child: SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: mandatoryContainer
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
                  product.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  "Items: ${product.quantity}",
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Row(
                  children: [
                    Text(
                      "Rs ${product.price}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        ((product.price) /
                                (1 - (product.discount / 100)))
                            .toStringAsFixed(0),
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 2.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "${product.discount}% OFF",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  color: Colors.green,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final cartProduct = CartModel(
      id: productId, // Use the product's ID
      name: product.name,
      description: product.details, // Assuming product.details is the description field
      price: product.price,
      imageUrl: product.imageUrl,
      discount: product.discount,
    );

    cartController.addToCart(cartProduct);
    onClick(widgetKey);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    languageController.isEnglish
                        ? "Add to Cart"
                        : "ٹوکری میں شامل کریں",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
