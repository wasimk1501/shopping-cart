import 'package:flutter/material.dart';
import 'package:practice17/product_model.dart';
import 'package:practice17/settings/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(name: 'Product 1', price: 10.0),
      Product(name: 'Product 2', price: 15.0),
      Product(name: 'Product 3', price: 20.0),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/cart'),
              icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () {
                  final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  cartProvider.addToCart(product);
                },
                child: const Text('Add to C A R T'),
              ),
            );
          }),
    );
  }
}
