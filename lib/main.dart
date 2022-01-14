import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import '../screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          //only works with objects based on classes that use the ChangeNotifier mixin(Products)
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId as String,
              previousProducts == null ? [] : previousProducts.items),
          create: (_) => Products('', '', []),
          // create: (ctx)=>Products(),
        ),
        ChangeNotifierProvider(
          //only works with objects based on classes that use the ChangeNotifier mixin(Products)
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders?>(
          //only works with objects based on classes that use the ChangeNotifier mixin(Products)
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
          create: (_) {},
          // create: (ctx)=>Products(),
        ),
      ],
      // when instantiate a class,use create method for efficiency
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          //MaterialApp rebuilt whenever Auth objects changes
          // child (_) is the stastic part
          debugShowCheckedModeBanner: false,
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
