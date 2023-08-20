import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:practice17/product_detail_screen.dart';
import 'package:practice17/models/product_model.dart';
import 'package:practice17/product_search_delegate.dart';
import 'package:practice17/settings/cart_provider.dart';
import 'package:practice17/settings/product_provider.dart';
// import 'package:practice17/settings/product_provider.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final List<Product> products =
        // [
        //   Product(name: 'Product 1', price: 10.0),
        //   Product(name: 'Product 2', price: 15.0),
        //   Product(name: 'Product 3', price: 20.0),
        // ];
        Provider.of<ProductProvider>(context, listen: false).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SHOPPY',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.purple
              ], // Customize the gradient colors
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final selectedProduct = await showSearch<Product>(
                context: context,
                delegate: ProductSearchDelegate(products),
              );
              if (!context.mounted) return;
              searchNavigator(context, selectedProduct);
            },
            icon: const Icon(Icons.search),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                icon: const Icon(Icons.shopping_cart),
              ),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Consumer<CartProvider>(
                    builder: (context, value, child) => Text(
                      value.cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product_image_${product.title}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        '${product.image}', // Replace with actual product image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        Consumer<ProductProvider>(
                          builder: (context, value, child) {
                            final prod = value.getProductByTitle(product.title);

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Handle favorite button tap
                                  value.toggleFavorite(prod);
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    prod.isFavorite ?? false
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              final cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false);
                              cartProvider.addToCart(product);
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Item added to cart')),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors
                                    .primaries[index % Colors.primaries.length],
                              ),
                              child: const Icon(Icons.add_shopping_cart,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // GestureDetector(
                          //   onTap: () {
                          //     // Handle buy now button tap
                          //   },
                          //   child: Container(
                          //     height: 50,
                          //     width: double.infinity,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(25),
                          //       color: Colors
                          //           .primaries[index % Colors.primaries.length],
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.primaries[
                          //                   index % Colors.primaries.length]
                          //               .withOpacity(0.3),
                          //           spreadRadius: 2,
                          //           blurRadius: 6,
                          //           offset: const Offset(0, 3),
                          //         ),
                          //       ],
                          //     ),
                          //     child: const Center(
                          //       child: Text(
                          //         'Buy Now',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void searchNavigator(BuildContext context, Product? selectedProduct) {
  if (selectedProduct != null) {
    // Do something with the selected product
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: selectedProduct),
      ),
    );
  } else {
    // User canceled the search without selecting anything
  }
}
