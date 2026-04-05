import 'package:flutter/material.dart';

class StoreDetailScreen extends StatelessWidget {
  final String storeId;

  const StoreDetailScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store')),
      body: Center(child: Text('Store \$storeId')),
    );
  }
}
