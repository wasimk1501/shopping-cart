import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:practice17/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];
  List<Product> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(
        0, (total, product) => total + (product.price * product.quantity));
  }

  Product? _removedItem;
  Product? get removedItem => _removedItem;

//Load cart items form shared preference
  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cartItems') ?? [];

    _cartItems =
        cartData.map((json) => Product.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

//Save cart items to shared preference
  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData =
        _cartItems.map((product) => jsonEncode(product.toJson())).toList();
    prefs.setStringList('cartItems', cartData);
  }

  void addToCart(Product product) {
    final existingProduct = _cartItems
        .firstWhere((item) => item.name == product.name, orElse: () => product);
    if (_cartItems.contains(existingProduct)) {
      increaseQuantity(_cartItems.indexOf(existingProduct));
    } else {
      _cartItems.add(product);
      saveCartItems();
      notifyListeners();
    }
  }

  void removeCartItem(int index) {
    _removedItem = _cartItems[index];
    _cartItems.removeAt(index);
    saveCartItems();
    notifyListeners();
  }

  void undoRemove() {
    if (_removedItem != null) {
      _cartItems.add(_removedItem!); //Add the removed item back to the cart
      _removedItem = null;
      saveCartItems();
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    saveCartItems();
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _cartItems[index].quantity++;
    saveCartItems();
    notifyListeners();
  }

  void removeAllItemsOfProduct(Product product) {
    _removedItem =
        _cartItems.firstWhereOrNull((item) => item.name == product.name);
    _cartItems.removeWhere((element) => element.name == product.name);

    saveCartItems();
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      saveCartItems();
      notifyListeners();
    } else {
      removeCartItem(index);
    }
  }

  void sortCartByName() {
    _cartItems.sort((a, b) => a.name.compareTo(b.name));
    saveCartItems();
    notifyListeners();
  }

  void sortCartByPrice() {
    _cartItems.sort((a, b) => a.price.compareTo(b.price));
    saveCartItems();
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    final index =
        _cartItems.indexWhere((product) => product.name == updatedProduct.name);
    if (index != -1) {
      _cartItems[index] = updatedProduct;
      saveCartItems();
      notifyListeners();
    }
  }

//Mark a  product as a favorite
  void toggleFavorite(Product product) {
    final index = _cartItems.indexWhere((prod) => prod.name == product.name);

    if (index != -1) {
      if (_cartItems[index].isFavorite == null)
        _cartItems[index].isFavorite = false;
      _cartItems[index].isFavorite = !_cartItems[index].isFavorite!;
      saveCartItems();
      notifyListeners();
    }
  }

  //Get the list of favorite products
  List<Product> getFavoriteProducts() {
    return _cartItems.where((product) => product.isFavorite ?? false).toList();
  }

  Product getProductByName(String name) {
    return _cartItems.firstWhere((product) => product.name == name,
        orElse: () => Product(name: '', price: 0.0, quantity: 0));
  }
}
