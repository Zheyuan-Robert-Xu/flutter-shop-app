import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import './providers/cart.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //only works with objects based on classes that use the ChangeNotifier mixin(Products)
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          //only works with objects based on classes that use the ChangeNotifier mixin(Products)
          create: (ctx) => Cart(),
        ),
      ],
      // when instantiate a class,use create method for efficiency
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
      ),
    );
  }
}
