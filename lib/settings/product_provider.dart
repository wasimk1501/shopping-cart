import 'package:flutter/material.dart';
import 'package:practice17/models/category_model.dart';
import 'package:practice17/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<Category> _categories = [
    Category(name: 'Electronics', icon: Icons.phone_android),
    Category(name: 'Clothing', icon: Icons.local_mall),
    Category(name: 'Books', icon: Icons.book),
    // Add more categories as needed
  ];
  List<Product> _products = [];

  ProductProvider() {
    // Initialize the list of products (you can replace this with your data source)
    _products = [
      Product(name: 'Product 1', price: 10.0, category: 'Electronics'),
      Product(name: 'Product 2', price: 15.0, category: 'Electronics'),
      Product(name: 'Product 3', price: 20.0, category: 'Electronics'),
      Product(name: 'Product 4', price: 25.0, category: 'Electronics'),
    ];
  }

  List<Product> get products => _products;

  void toggleFavorite(Product product) {
    final index = _products.indexWhere((p) => p.name == product.name);
    if (index != -1) {
      _products[index].isFavorite = !_products[index].isFavorite!;
      notifyListeners();
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }
}
