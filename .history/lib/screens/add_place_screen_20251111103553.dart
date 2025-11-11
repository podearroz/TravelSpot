import 'package:flutter/material.dart';
import '../models/place.dart';
import '../services/supabase_service.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _name = TextEditingController();
  final _type = TextEditingController();
  final _cuisine = TextEditingController();
  final _description = TextEditingController();
  bool _loading = false;

  Future<void> _save() async {
    setState(() => _loading = true);
    final place = Place(
      id: '',
      name: _name.text.trim(),
      type: _type.text.trim(),
      cuisine: _cuisine.text.trim(),
      description: _description.text.trim(),
    );
    final ok = await SupabaseService.addPlace(place);
    setState(() => _loading = false);
    if (ok) Navigator.pop(context, true);
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar lugar')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: _type, decoration: const InputDecoration(labelText: 'Tipo (restaurante, bar, etc.)')),
            TextField(controller: _cuisine, decoration: const InputDecoration(labelText: 'Tipo de comida')),
            TextField(controller: _description, decoration: const InputDecoration(labelText: 'Descrição'), maxLines: 3),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loading ? null : _save, child: _loading ? const CircularProgressIndicator() : const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
