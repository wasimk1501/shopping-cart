import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:practice17/product_list_screen.dart';
import 'package:practice17/settings/cart_provider.dart';
import 'package:practice17/cart_screen.dart';
import 'package:practice17/settings/category_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final cartProvider = CartProvider();
  await cartProvider
      .loadCartItems(); //Initialized cart items from shared preference
  runApp(MyApp(cartProvider: cartProvider));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.cartProvider});
  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: cartProvider,
        ),
        ChangeNotifierProxyProvider<CategoryProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, categoryProvider, productProvider) {
            return productProvider
              ..setCategories(categoryProvider.categories); //TODO
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        title: 'Shopping App',
        initialRoute: '/',
        routes: {
          '/': (context) => const ProductListScreen(),
          '/cart': (context) => const CartScreen()
        },
      ),
    );
  }
}
