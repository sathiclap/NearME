import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchmystore/providers/cart_provider.dart';
import 'package:searchmystore/providers/shops_provider.dart';
import 'package:searchmystore/providers/products_provider.dart';
import 'package:searchmystore/screens/home_screen.dart';
import 'package:searchmystore/utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ShopsProvider()),
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'ShopNearME',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}