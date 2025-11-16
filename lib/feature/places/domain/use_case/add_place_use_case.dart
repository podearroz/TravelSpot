import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/domain/repository/places_repository.dart';

class AddPlaceParams {
  final String name;
  final String? description;
  final int? placeTypeId;
  final List<int> cuisineIds;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? ownerId;
  final String? imageUrl;

  AddPlaceParams({
    required this.name,
    this.description,
    this.placeTypeId,
    this.cuisineIds = const [],
    this.address,
    this.latitude,
    this.longitude,
    this.ownerId,
    this.imageUrl,
  });
}

class AddPlaceUseCase {
  final PlacesRepository _repository;

  AddPlaceUseCase(this._repository);

  Future<Try<Place>> call(AddPlaceParams params) async {
    return await _repository.addPlace(params);
  }
}
