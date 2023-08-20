import 'package:flutter/material.dart';
import 'package:practice17/pages/edit_product_screen.dart';
import 'package:practice17/models/product_model.dart';
import 'package:practice17/settings/cart_provider.dart';
import 'package:practice17/settings/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartItemsCount = cartProvider.cartItems.length;
    final removedItem = cartProvider.removedItem;
    final isFavorite =
        productProvider.getProductByName(product.name)?.isFavorite ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to the cart screen.
                },
                icon: Icon(
                  Icons.shopping_cart,
                  size: 28,
                ),
              ),
              if (cartItemsCount > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      '$cartItemsCount',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Hero(
                  tag: 'product_image_${product.name}',
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/shopping-cart.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: GestureDetector(
                      key: ValueKey<bool>(isFavorite),
                      onTap: () {
                        productProvider.toggleFavorite(product);
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Product Description:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Nulla ultrices vestibulum convallis. Proin ullamcorper '
                    'facilisis urna, id consequat dolor vulputate vitae.',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AnimatedButton(
                          onPressed: () {
                            cartProvider.addToCart(product);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('🥳 ${product.name} added to 🛒'),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'View Cart',
                                onPressed: () {
                                  // Navigate to the cart screen.
                                },
                              ),
                            ));
                          },
                          color: Colors.blue[600],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_shopping_cart,
                                  color: Colors.white),
                              SizedBox(width: 8),
                              Text('Add to Cart',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: AnimatedButton(
                          onPressed: () {
                            cartProvider.removeAllItemsOfProduct(product);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'All items of this product removed from cart'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () => cartProvider.undoRemove(),
                                ),
                              ),
                            );
                          },
                          color: Colors.red[600],
                          child: Text('Remove All Items',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProductScreen(product: product),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 3,
                      shadowColor: Colors.green.withOpacity(
                          0.4), // Add a subtle shadow to the button.
                    ),
                    child: Text('Edit Product Details',
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? color;

  AnimatedButton({this.onPressed, this.child, this.color});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController
            .forward()
            .then((_) => _animationController.reverse());
        widget.onPressed?.call();
      },
      child: ScaleTransition(
        scale: _animationController,
        child: Material(
          color: widget.color,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
