import 'package:get/get.dart';

import '../models/cart_model.dart';

class AppStateController extends GetxController {
  RxList<CartModel> cartItems = <CartModel>[].obs;

  void addToCart(CartModel product) {
    final existingProduct = cartItems.firstWhere(
      (item) => item.id == product.id,
      orElse: () => CartModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );

    if (existingProduct.count == 0) {
      cartItems.add(existingProduct);
    }

    existingProduct.count++;
  }

  void removeFromCart(CartModel product) {
    final existingProduct = cartItems.firstWhere(
      (item) => item.id == product.id,
      orElse: () => CartModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );

    if (existingProduct.count > 0) {
      existingProduct.count--;

      if (existingProduct.count == 0) {
        cartItems.remove(existingProduct);
      }
    }
  }
}
