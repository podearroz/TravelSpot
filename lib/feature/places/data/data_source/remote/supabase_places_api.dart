import 'package:chopper/chopper.dart';

part 'supabase_places_api.chopper.dart';

@ChopperApi()
abstract class SupabasePlacesApi extends ChopperService {
  @GET(path: '/places')
  Future<Response<dynamic>> getAllPlaces();

  @GET(path: '/places/{id}')
  Future<Response<dynamic>> getPlaceById(@Path('id') String id);

  @POST(path: '/places')
  Future<Response<dynamic>> addPlace(
    @Body() Map<String, dynamic> place,
  );

  @Patch(path: '/places/{id}')
  Future<Response<dynamic>> updatePlace(
    @Path('id') String id,
    @Body() Map<String, dynamic> updates,
  );

  @DELETE(path: '/places/{id}')
  Future<Response<dynamic>> deletePlace(@Path('id') String id);

  @GET(path: '/place_types')
  Future<Response<dynamic>> getPlaceTypes();

  @GET(path: '/cuisines')
  Future<Response<dynamic>> getCuisines();

  static SupabasePlacesApi create(ChopperClient client) =>
      _$SupabasePlacesApi(client);
}
