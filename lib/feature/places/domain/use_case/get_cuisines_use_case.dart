import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';
import 'package:travelspot/feature/places/domain/repository/places_repository.dart';

class GetCuisinesUseCase {
  final PlacesRepository _repository;

  GetCuisinesUseCase(this._repository);

  Future<Try<List<Cuisine>>> call() async {
    return await _repository.getCuisines();
  }
}
