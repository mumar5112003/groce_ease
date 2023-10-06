import 'dart:convert';

import 'package:get/get.dart';
import 'package:groce_ease/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartController extends GetxController {
  RxList<CartModel> cartItems = <CartModel>[].obs;

  // SharedPreferences key for storing cart items
  static const String cartKey = 'cart';

  @override
  void onInit() {
    super.onInit();
    // Load cart items from SharedPreferences when the controller initializes
    loadCartItems();
  }

  Future<void> addToCart(CartModel product) async {
    final existingProduct = cartItems.firstWhere(
      (item) => item.id == product.id,
      orElse: () => product.copyWith(),
    );

    if(existingProduct.count==0){
      existingProduct.count++;
      cartItems.add(existingProduct);
    }
    else{
      existingProduct.count++;
    }



    // Save the updated cart items to SharedPreferences
    await saveCartItems();
  }

  Future<void> removeFromCart(CartModel product) async {
    final existingProduct = cartItems.firstWhere(
      (item) => item.id == product.id,
      orElse: () => product.copyWith(),
    );

    if (existingProduct.count > 1) {
      existingProduct.count--;

      if (existingProduct.count == 1) {
        cartItems.remove(existingProduct);
      }

      // Save the updated cart items to SharedPreferences
      await saveCartItems();
    }
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (final item in cartItems) {
      totalPrice += item.price * item.count;
    }
    return totalPrice;
  }

  int getTotalItems() {
    int totalItems = 0;
    for (final item in cartItems) {
      totalItems += item.count;
    }
    return totalItems;
  }

  double getTotalDiscount() {
    double totalDiscount = 0.0;
    for (final item in cartItems) {
      totalDiscount += (item.discount * item.price * item.count) / 100;
    }
    return totalDiscount;
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString(cartKey);

    if (cartData != null) {
      final List<CartModel> savedCartItems =
          (json.decode(cartData) as List<dynamic>)
              .map((item) => CartModel.fromMap(item))
              .toList();

      cartItems.assignAll(savedCartItems);
    }
  }

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(cartItems.map((item) => item.toMap()).toList());

    await prefs.setString(cartKey, cartData);
  }
}
