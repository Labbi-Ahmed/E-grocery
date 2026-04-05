import 'package:flutter/material.dart';

class NewAddressScreen extends StatelessWidget {
  const NewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Address')),
      body: const Center(child: Text('New Address')),
    );
  }
}
