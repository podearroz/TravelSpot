import 'package:travelspot/feature/places/data/data_source/remote/places_remote_data_source.dart';
import 'package:travelspot/feature/places/data/data_source/remote/supabase_places_api.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';
import 'package:travelspot/feature/places/domain/use_case/add_place_use_case.dart';

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  final SupabasePlacesApi _api;

  PlacesRemoteDataSourceImpl(this._api);

  @override
  Future<List<Place>> getPlaces({int? limit, int? offset}) async {
    final response = await _api.getAllPlaces();

    if (response.isSuccessful && response.body != null) {
      final data = response.body!;
      if (data is List) {
        return data
            .map((json) => Place.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List;
        return list
            .map((json) => Place.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('Failed to get places: ${response.statusCode}');
  }

  @override
  Future<Place> getPlaceById(String id) async {
    final response = await _api.getPlaceById(id);

    if (response.isSuccessful && response.body != null) {
      final data = response.body!;
      if (data is List && data.isNotEmpty) {
        return Place.fromJson(data.first as Map<String, dynamic>);
      } else if (data is Map<String, dynamic>) {
        if (data.containsKey('data')) {
          final itemData = data['data'];
          if (itemData is List && itemData.isNotEmpty) {
            return Place.fromJson(itemData.first as Map<String, dynamic>);
          } else if (itemData is Map<String, dynamic>) {
            return Place.fromJson(itemData);
          }
        } else {
          return Place.fromJson(data);
        }
      }
    }

    throw Exception('Place not found: $id');
  }

  @override
  Future<Place> addPlace(AddPlaceParams params) async {
    final placeData = {
      'name': params.name,
      'description': params.description,
      'address': params.address,
      'latitude': params.latitude,
      'longitude': params.longitude,
      'place_type_id': params.placeTypeId,
      'owner_id': params.ownerId,
      'image_url': params.imageUrl, // Adicionado aqui
      'is_published': true,
    };

    final response = await _api.addPlace(placeData);

    if (response.isSuccessful && response.body != null) {
      final data = response.body!;
      if (data is List && data.isNotEmpty) {
        return Place.fromJson(data.first as Map<String, dynamic>);
      } else if (data is Map<String, dynamic>) {
        if (data.containsKey('data')) {
          final itemData = data['data'];
          if (itemData is List && itemData.isNotEmpty) {
            return Place.fromJson(itemData.first as Map<String, dynamic>);
          } else if (itemData is Map<String, dynamic>) {
            return Place.fromJson(itemData);
          }
        } else {
          return Place.fromJson(data);
        }
      }
    }

    throw Exception('Failed to create place: ${response.statusCode}');
  }

  @override
  Future<Place> updatePlace(String id, Map<String, dynamic> updates) async {
    final response = await _api.updatePlace(id, updates);

    if (response.isSuccessful && response.body != null) {
      final data = response.body!;
      if (data is List && data.isNotEmpty) {
        return Place.fromJson(data.first as Map<String, dynamic>);
      } else if (data is Map<String, dynamic>) {
        if (data.containsKey('data')) {
          final itemData = data['data'];
          if (itemData is List && itemData.isNotEmpty) {
            return Place.fromJson(itemData.first as Map<String, dynamic>);
          } else if (itemData is Map<String, dynamic>) {
            return Place.fromJson(itemData);
          }
        } else {
          return Place.fromJson(data);
        }
      }
    }

    throw Exception('Failed to update place: ${response.statusCode}');
  }

  @override
  Future<void> deletePlace(String id) async {
    final response = await _api.deletePlace(id);

    if (!response.isSuccessful) {
      throw Exception('Failed to delete place: ${response.statusCode}');
    }
  }

  @override
  Future<List<PlaceType>> getPlaceTypes() async {
    final response = await _api.getPlaceTypes();

    if (response.isSuccessful && response.body != null) {
      final data = response.body!;
      if (data is List) {
        return data
            .map((json) => PlaceType.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List;
        return list
            .map((json) => PlaceType.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('Failed to get place types: ${response.statusCode}');
  }

  @override
  Future<List<Cuisine>> getCuisines() async {
    final response = await _api.getCuisines();

    if (response.isSuccessful && response.body != null) {
      final data = response.body!;
      if (data is List) {
        return data
            .map((json) => Cuisine.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List;
        return list
            .map((json) => Cuisine.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('Failed to get cuisines: ${response.statusCode}');
  }
}
