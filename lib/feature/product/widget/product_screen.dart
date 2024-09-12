import 'package:flutter/material.dart';

/// {@template product_screen}
/// ProductScreen widget.
/// {@endtemplate}
class ProductScreen extends StatelessWidget {
  /// {@macro product_screen}
  const ProductScreen({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Product'),
        ),
        body: SafeArea(
          child: Center(
            child: Text('Product: $productId'),
          ),
        ),
      );
}
