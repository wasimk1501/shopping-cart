import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:practice17/product_detail_screen.dart';
import 'package:practice17/product_model.dart';
import 'package:practice17/product_search_delegate.dart';
import 'package:practice17/settings/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final List<Product> products = [
      Product(name: 'Product 1', price: 10.0),
      Product(name: 'Product 2', price: 15.0),
      Product(name: 'Product 3', price: 20.0),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          (IconButton(
              onPressed: () async {
                // showSearch<Product>(
                //   context: context, delegate: ProductSearchDelegate(products));
                final selectedProduct = await showSearch<Product>(
                  context: context,
                  delegate: ProductSearchDelegate(products),
                );
                if (!context.mounted) return;
                searchNavigator(context, selectedProduct);
              },
              icon: Icon(Icons.search))),
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/cart'),
              icon: Stack(
                fit: StackFit.loose,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 40,
                  ),
                  Container(
                    width: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Consumer<CartProvider>(
                      builder: (context, value, child) => Center(
                          child: Text(value.cartItems.length.toString())),
                    ),
                  )
                ],
              ))
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
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item added to cart')),
                  );
                },
                child: const Text('Add to C A R T'),
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product))),
            );
          }),
    );
  }
}

void searchNavigator(BuildContext context, Product? selectedProduct) {
  if (selectedProduct != null) {
    // Do something with the selected product
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(product: selectedProduct)));
  } else {
    // User canceled the search without selecting anything
  }
}
