import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';
import 'package:travelspot/feature/places/domain/use_case/add_place_use_case.dart';

abstract class PlacesRepository {
  Future<Try<List<Place>>> getPlaces({int? limit, int? offset});
  Future<Try<Place>> getPlaceById(String id);
  Future<Try<Place>> addPlace(AddPlaceParams params);
  Future<Try<Place>> updatePlace(String id, Map<String, dynamic> updates);
  Future<Try<void>> deletePlace(String id);
  Future<Try<List<PlaceType>>> getPlaceTypes();
  Future<Try<List<Cuisine>>> getCuisines();
}
