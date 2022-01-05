import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // ProductDetailScreen(this.title,this.price); // passing data via constructors can be cumbersome & difficult;
  //Unnecessary rebuilds of the entire app or major parts of the app
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String; //id
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(
        productId); //listen: true--->build method of the widget in which you're using provider of will
    // will return whenever the provided object-- In short rebuilt
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title as String),
      ),
    );
  }
}
