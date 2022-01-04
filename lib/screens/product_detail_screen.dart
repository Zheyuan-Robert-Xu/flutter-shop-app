import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // ProductDetailScreen(this.title,this.price); // passing data via constructors can be cumbersome & difficult;
  //Unnecessary rebuilds of the entire app or major parts of the app
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String; //id
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
