import 'dart:convert';

class Product {
  final String imageUrl;
  final String name;
  final double price;
  final double discount;
  final int quantity;
  final String details;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'details': details,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      discount: map['discount'] as double,
      quantity: map['quantity'] as int,
      details: map['details'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
