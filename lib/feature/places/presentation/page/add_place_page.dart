import 'package:flutter/material.dart';

class AddPlacePage extends StatelessWidget {
  const AddPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place'),
      ),
      body: const Center(
        child: Text(
          'Add Place Form - Implementation Pending',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}