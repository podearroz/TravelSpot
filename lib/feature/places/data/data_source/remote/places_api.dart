import 'package:chopper/chopper.dart';
import 'package:travelspot/feature/places/data/model/place_model.dart';

part 'places_api.chopper.dart';

@ChopperApi()
abstract class PlacesApi extends ChopperService {
  @GET(path: "/places")
  Future<Response<List<PlaceModel>>> getPlaces();

  @GET(path: "/places/{id}")
  Future<Response<PlaceModel>> getPlaceById(@Path() String id);

  @POST(path: "/places")
  Future<Response<PlaceModel>> createPlace(@Body() PlaceModel place);

  @PUT(path: "/places/{id}")
  Future<Response<PlaceModel>> updatePlace(@Path() String id, @Body() PlaceModel place);

  @DELETE(path: "/places/{id}")
  Future<Response<void>> deletePlace(@Path() String id);

  static PlacesApi create(ChopperClient client) {
    return _$PlacesApi(client);
  }
}