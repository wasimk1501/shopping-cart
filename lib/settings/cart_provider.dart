import 'package:flutter/material.dart';
import 'package:practice17/product_model.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(
        0, (total, product) => total + (product.price * product.quantity));
  }

  void addToCart(Product product) {
    final existingProduct = _cartItems
        .firstWhere((item) => item.name == product.name, orElse: () => product);
    if (_cartItems.contains(existingProduct)) {
      increaseQuantity(_cartItems.indexOf(existingProduct));
    } else {
      _cartItems.add(product);
      notifyListeners();
    }
  }

  void removeCartItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    } else {
      removeCartItem(index);
    }
  }
}
