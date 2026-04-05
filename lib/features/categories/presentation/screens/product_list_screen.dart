import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Center(child: Text('Products for \$categoryName')),
    );
  }
}
