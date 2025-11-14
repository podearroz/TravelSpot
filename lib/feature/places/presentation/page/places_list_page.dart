import 'package:flutter/material.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add-place');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Places List - Implementation Pending',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}