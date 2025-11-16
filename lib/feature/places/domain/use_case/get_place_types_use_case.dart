import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/feature/places/domain/repository/places_repository.dart';

class GetPlaceTypesUseCase {
  final PlacesRepository _repository;

  GetPlaceTypesUseCase(this._repository);

  Future<Try<List<PlaceType>>> call() async {
    return await _repository.getPlaceTypes();
  }
}
