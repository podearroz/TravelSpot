import 'package:flutter/material.dart';
import '../models/place.dart';
import '../services/supabase_service.dart';
import 'place_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Place> _places = [];
  bool _loading = true;
  String? _filterType;
  String? _filterCuisine;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    setState(() => _loading = true);
    final list = await SupabaseService.fetchPlaces(
        type: _filterType, cuisine: _filterCuisine);
    setState(() {
      _places = list;
      _loading = false;
    });
  }

  Future<void> _openFilterDialog() async {
    final typeCtrl = TextEditingController(text: _filterType ?? '');
    final cuisineCtrl = TextEditingController(text: _filterCuisine ?? '');
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: typeCtrl,
                decoration: const InputDecoration(labelText: 'Tipo')),
            TextField(
                controller: cuisineCtrl,
                decoration: const InputDecoration(labelText: 'Culinária')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Aplicar')),
        ],
      ),
    );
    if (res == true) {
      _filterType = typeCtrl.text.trim().isEmpty ? null : typeCtrl.text.trim();
      _filterCuisine =
          cuisineCtrl.text.trim().isEmpty ? null : cuisineCtrl.text.trim();
      await _loadPlaces();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelSpot - Lugares'),
        actions: [
          IconButton(
              onPressed: _openFilterDialog, icon: const Icon(Icons.filter_list))
        ],
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
                        ? Image.network(p.imageUrl!,
                            width: 56, height: 56, fit: BoxFit.cover)
                        : const Icon(Icons.place),
                    title: Text(p.name),
                    subtitle: Text('${p.type} • ${p.cuisine}'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PlaceDetailScreen(place: p)),
                    ),
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
