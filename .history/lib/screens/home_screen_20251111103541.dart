import 'package:flutter/material.dart';
import '../models/place.dart';
import '../services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Place> _places = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    setState(() => _loading = true);
    final list = await SupabaseService.fetchPlaces();
    setState(() {
      _places = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelSpot - Lugares'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPlaces,
              child: ListView.builder(
                itemCount: _places.length,
                itemBuilder: (context, index) {
                  final p = _places[index];
                  return ListTile(
                    leading: p.imageUrl != null
                        ? Image.network(p.imageUrl!, width: 56, height: 56, fit: BoxFit.cover)
                        : const Icon(Icons.place),
                    title: Text(p.name),
                    subtitle: Text('${p.type} • ${p.cuisine}'),
                    onTap: () => Navigator.pushNamed(context, '/add'),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
