import 'package:dartz/dartz.dart';
import 'package:travelspot/core/errors/failure.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';

abstract class PlacesRepository {
  Future<Either<Failure, List<Place>>> getPlaces();
  Future<Either<Failure, Place>> getPlaceById(String id);
  Future<Either<Failure, Place>> createPlace(Place place);
  Future<Either<Failure, Place>> updatePlace(Place place);
  Future<Either<Failure, void>> deletePlace(String id);
}
