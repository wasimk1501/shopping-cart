import 'package:practice17/models/category_model.dart';

class Product {
  final String name;
  final double price;
  int quantity;
  bool? isFavorite;
  Category category;
  Product(
      {required this.name,
      required this.price,
      this.quantity = 1,
      this.isFavorite = false,
      required this.category});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'] ?? '');
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
        'isFavorite': isFavorite,
        'category': category
      };
}
