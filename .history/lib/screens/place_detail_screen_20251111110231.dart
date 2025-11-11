import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/place.dart';
import '../models/review.dart';
import '../services/supabase_service.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  List<Review> _reviews = [];
  bool _loading = true;

  final _ratingController = TextEditingController(text: '5');
  final _commentController = TextEditingController();
  Uint8List? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _loading = true);
    final list = await SupabaseService.fetchReviews(widget.place.id);
    setState(() {
      _reviews = list;
      _loading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _pickedImage = bytes);
  }

  Future<void> _submitReview() async {
    final rating = int.tryParse(_ratingController.text) ?? 5;
    final comment = _commentController.text.trim();
    String? imageUrl;
    if (_pickedImage != null) {
      final fileName = '${widget.place.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      imageUrl = await SupabaseService.uploadImage(fileName, _pickedImage!);
    }
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      placeId: widget.place.id,
      userId: 'anonymous',
      rating: rating,
      comment: comment,
      imageUrl: imageUrl,
    );
    final ok = await SupabaseService.addReview(review);
    if (ok) {
      _commentController.clear();
      setState(() => _pickedImage = null);
      await _loadReviews();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao enviar avaliação')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.place.name)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.place.type + ' • ' + widget.place.cuisine, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(widget.place.description),
            const Divider(),
            const Text('Avaliações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _loading ? const Center(child: CircularProgressIndicator()) : Expanded(
              child: _reviews.isEmpty ? const Center(child: Text('Nenhuma avaliação ainda')) : ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, i) {
                  final r = _reviews[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(r.rating.toString())),
                    title: Text(r.comment),
                    subtitle: Text('Usuário: ${r.userId}'),
                    trailing: r.imageUrl != null ? Image.network(r.imageUrl!, width: 56, height: 56, fit: BoxFit.cover) : null,
                  );
                },
              ),
            ),
            const Divider(),
            const Text('Adicionar avaliação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(children: [
              const Text('Nota:'),
              const SizedBox(width: 8),
              SizedBox(width: 60, child: TextField(controller: _ratingController, keyboardType: TextInputType.number))
            ]),
            TextField(controller: _commentController, decoration: const InputDecoration(labelText: 'Comentário')),
            Row(children: [
              ElevatedButton(onPressed: _pickImage, child: const Text('Escolher foto')),
              const SizedBox(width: 8),
              if (_pickedImage != null) const Text('Imagem selecionada')
            ]),
            ElevatedButton(onPressed: _submitReview, child: const Text('Enviar avaliação')),
          ],
        ),
      ),
    );
  }
}
