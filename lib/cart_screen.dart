import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:practice17/models/product_model.dart';
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
          'CART',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Sort By Name',
            onPressed: () => cartProvider.sortCartByName(),
            icon: Icon(Icons.sort_by_alpha_rounded),
          ),
          IconButton(
            tooltip: 'Sort By Price',
            onPressed: () => cartProvider.sortCartByPrice(),
            icon: Icon(Icons.sort_rounded),
          ),
        ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Colors.blue[50]!,
        //       Colors.blue[100]!,
        //       Colors.blue[200]!,
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            final cartItems = cartProvider.cartItems;
            if (cartItems.isEmpty)
              return Center(
                child: Text('Your CART is empty.'),
              );
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                log('Product: ${product.toJson()}');
                log('List index: $index');
                return Dismissible(
                  key: ValueKey(product.name),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    cartProvider.removeCartItem(index);
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${product.name} removed from the cart'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => cartProvider.undoRemove(),
                      ),
                    ));
                  },
                  child: AnimatedCard(
                    product: product,
                    onPressed: () => cartProvider.removeCartItem(index),
                    index: index,
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[300]!, Colors.blue[500]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price: ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Selector<CartProvider, double>(
                      selector: (context, cartProvider) =>
                          cartProvider.totalPrice,
                      builder: (context, totalPrice, child) => Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        cartProvider.clearCart();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('CART cleared')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'Clear Cart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: cartItems.isNotEmpty
          ? AnimatedFloatingActionButton(
              onPressed: () {
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                cartProvider.clearCart();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CART cleared')),
                );
              },
              child: Icon(Icons.clear),
            )
          : null,
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final Product product;
  final VoidCallback onPressed;
  final int index;

  const AnimatedCard({
    super.key,
    required this.product,
    required this.onPressed,
    required this.index,
  });

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: widget.onPressed,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: Transform.scale(
        scale: _animation.value,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              widget.product.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('\$${widget.product.price.toStringAsFixed(1)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CartQuantityControl(index: widget.index),
                IconButton(
                  onPressed: widget.onPressed,
                  icon: Icon(Icons.delete),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ... (remaining code remains unchanged)
class CartQuantityControl extends StatelessWidget {
  final int index;
  const CartQuantityControl({super.key, required this.index});
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
          icon: Icon(Icons.remove),
        ),
        AnimatedQuantityChange(
          quantity: product.quantity,
        ),
        IconButton(
          onPressed: () {
            cartProvider.increaseQuantity(index);
            log('increased Quantity Index : $index');
          },
          icon: Icon(Icons.add),
        )
      ],
    );
  }
}

class AnimatedQuantityChange extends StatelessWidget {
  final int quantity;
  const AnimatedQuantityChange({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: quantity - 1, end: quantity),
      duration: Duration(milliseconds: 500),
      builder: (context, int value, child) {
        return Text(
          value.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      },
    );
  }
}

class AnimatedFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  _AnimatedFloatingActionButtonState createState() =>
      _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState
    extends State<AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
