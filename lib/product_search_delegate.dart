import 'package:flutter/material.dart';
import 'package:practice17/product_detail_screen.dart';
import 'package:practice17/product_model.dart';

class ProductSearchDelegate extends SearchDelegate<Product> {
  final List<Product> products;
  ProductSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    final result = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        final product = result[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          trailing: ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(product: product))),
            child: Text('Details'),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        final product = result[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          trailing: ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(product: product))),
            child: Text('Details'),
          ),
        );
      },
    );
  }
}
