import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:practice17/product_model.dart';
import 'package:practice17/settings/cart_provider.dart';

import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final List<Product> cartItems = cartProvider.cartItems;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'C A R T',
          style: const TextTheme().headlineLarge,
        ),
      ),
      body: Consumer<CartProvider>(
       builder: (context, cartProvider, child) {
          final cartItems = cartProvider.cartItems;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final product = cartItems[index];
              log('Product: ${product.toJson()}');
              log('List index: $index');
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(1)}'),
                trailing: CartQuantityControl(
                  index: index,
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Selector<CartProvider, double>(
        selector: (context, cartProvider) => cartProvider.totalPrice,
        builder: (context, totalPrice, child) => Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Total Price: \$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          final cartProvider =
              Provider.of<CartProvider>(context, listen: false);
          cartProvider.clearCart();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('C A R T cleared')));
        },
        child: const Icon(Icons.clear),
      ),
    );
  }
}

class CartQuantityControl extends StatelessWidget {
  final int index;
  const CartQuantityControl({required this.index});
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final product = cartProvider.cartItems[index];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () {
              cartProvider.decreaseQuantity(index);
              log('decreased Quantity Index : $index');
            },
            icon: Icon(Icons.remove)),
        Text(product.quantity.toString()),
        IconButton(
            onPressed: () {
              cartProvider.increaseQuantity(index);
              log('increased Quantity Index : $index');
            },
            icon: Icon(Icons.add))
      ],
    );
  }
}
