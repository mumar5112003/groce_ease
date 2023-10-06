// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groce_ease/controller/cart_controller.dart';


class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find();

   CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final cartItems = cartController.cartItems;
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    leading: Image.network(item.imageUrl),
                    title: Text(item.name),
                    subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            cartController.removeFromCart(item);
                          },
                        ),
                        Text(item.count.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cartController.addToCart(item);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[300],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Items: ${cartController.getTotalItems()}'),
                    Text('Total Price: \$${cartController.getTotalPrice().toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Total Discount: \$${cartController.getTotalDiscount().toStringAsFixed(2)}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Place your order or perform checkout actions here
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
