import 'package:flutter/material.dart';
import 'package:practice17/product_list_screen.dart';
import 'package:practice17/settings/cart_provider.dart';
import 'package:practice17/cart_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        title: 'Shopping App',
        initialRoute: '/',
        routes: {
          '/': (context) => ProductListScreen(),
          '/cart': (context) => CartScreen()
        },
      ),
    );
  }
}
