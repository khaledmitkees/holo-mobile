import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'features/products/presentation/providers/products_list_provider.dart';
import 'features/carts/presentation/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holo Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductsListProvider(),
        '/cart': (context) => const CartProvider(),
      },
    );
  }
}
