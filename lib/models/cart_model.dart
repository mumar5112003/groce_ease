import 'dart:convert';

class CartModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double discount;
  int count=0;

  CartModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.discount,
   this.count=0,
  });

  // Create a copy of the CartModel with an updated count
  CartModel copyWith({int? count}) {
    return CartModel(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      discount: discount,
      count: count ?? this.count,
    );
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      discount: map['discount'] as double,
      count: map['count'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'discount': discount,
      'count': count,
    };
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
