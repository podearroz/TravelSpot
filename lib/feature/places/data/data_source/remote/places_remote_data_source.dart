import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';
import 'package:travelspot/feature/places/domain/use_case/add_place_use_case.dart';

abstract class PlacesRemoteDataSource {
  Future<List<Place>> getPlaces({int? limit, int? offset});
  Future<Place> getPlaceById(String id);
  Future<Place> addPlace(AddPlaceParams params);
  Future<Place> updatePlace(String id, Map<String, dynamic> updates);
  Future<void> deletePlace(String id);
  Future<List<PlaceType>> getPlaceTypes();
  Future<List<Cuisine>> getCuisines();
}
