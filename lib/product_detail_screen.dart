import 'package:flutter/material.dart';
import 'package:practice17/product_model.dart';
import 'package:practice17/settings/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsCount = cartProvider.cartItems.length;
    final removedItem = cartProvider.removedItem;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Consumer<CartProvider>(
                builder: (context, provider, child) {
                  final productInCart = provider.cartItems.firstWhereOrNull(
                    (Product? element) => element?.name == product.name,
                    // Return null as the default value if no matching element is found.
                  );
                  final quantityInCart = productInCart?.quantity ?? 0;
                  return Text('$quantityInCart items');
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Product Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Nulla ultrices vestibulum convallis. Proin ullamcorper '
              'facilisis urna, id consequat dolor vulputate vitae.',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
                onPressed: () {
                  cartProvider.addToCart(product);
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('🥳 ${product.name} added to 🛒')));
                },
                child: const Text('Add to C A R T')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                cartProvider.removeAllItemsOfProduct(product);
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('All items of this product removed from cart'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => cartProvider.undoRemove(),
                    ),
                  ),
                );
              },
              child: const Text('Remove All Items of this Product'),
            ),
          ],
        ),
      ),
    );
  }
}
