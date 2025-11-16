import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';
import 'package:travelspot/feature/places/domain/repository/places_repository.dart';
import 'package:travelspot/feature/places/domain/use_case/add_place_use_case.dart';
import 'package:travelspot/feature/places/data/data_source/remote/places_remote_data_source.dart';
import 'package:travelspot/core/errors/failure.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource _remoteDataSource;

  PlacesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Try<List<Place>>> getPlaces({int? limit, int? offset}) async {
    try {
      final places =
          await _remoteDataSource.getPlaces(limit: limit, offset: offset);
      return Success(places);
    } catch (e) {
      return Rejection(ServerFailure('Failed to get places: ${e.toString()}'));
    }
  }

  @override
  Future<Try<Place>> getPlaceById(String id) async {
    try {
      final place = await _remoteDataSource.getPlaceById(id);
      return Success(place);
    } catch (e) {
      return Rejection(ServerFailure('Failed to get place: ${e.toString()}'));
    }
  }

  @override
  Future<Try<Place>> addPlace(AddPlaceParams params) async {
    try {
      final place = await _remoteDataSource.addPlace(params);
      return Success(place);
    } catch (e) {
      return Rejection(ServerFailure('Failed to add place: ${e.toString()}'));
    }
  }

  @override
  Future<Try<Place>> updatePlace(
      String id, Map<String, dynamic> updates) async {
    try {
      final place = await _remoteDataSource.updatePlace(id, updates);
      return Success(place);
    } catch (e) {
      return Rejection(
          ServerFailure('Failed to update place: ${e.toString()}'));
    }
  }

  @override
  Future<Try<void>> deletePlace(String id) async {
    try {
      await _remoteDataSource.deletePlace(id);
      return Success(null);
    } catch (e) {
      return Rejection(
          ServerFailure('Failed to delete place: ${e.toString()}'));
    }
  }

  @override
  Future<Try<List<PlaceType>>> getPlaceTypes() async {
    try {
      final placeTypes = await _remoteDataSource.getPlaceTypes();
      return Success(placeTypes);
    } catch (e) {
      return Rejection(
          ServerFailure('Failed to get place types: ${e.toString()}'));
    }
  }

  @override
  Future<Try<List<Cuisine>>> getCuisines() async {
    try {
      final cuisines = await _remoteDataSource.getCuisines();
      return Success(cuisines);
    } catch (e) {
      return Rejection(
          ServerFailure('Failed to get cuisines: ${e.toString()}'));
    }
  }
}
