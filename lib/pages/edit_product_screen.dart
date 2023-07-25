import 'package:flutter/material.dart';
import 'package:practice17/models/product_model.dart';
import 'package:practice17/settings/cart_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});
  final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: () {
                  final newName = _nameController.text;

                  final newPrice =
                      double.tryParse(_priceController.text) ?? 0.0;
                  if (newName.isNotEmpty && newPrice > 0) {
                    final updatedProduct = Product(
                        name: newName,
                        price: newPrice,
                        quantity: widget.product.quantity,
                        category: widget.product.category);
                    Provider.of<CartProvider>(context, listen: false)
                        .updateProduct(updatedProduct);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter valid product details')));
                  }
                },
                child: const Text('Save Changes'))
          ],
        ),
      ),
    );
  }
}
