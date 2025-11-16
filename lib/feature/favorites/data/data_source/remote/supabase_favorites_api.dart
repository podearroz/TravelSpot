import 'package:chopper/chopper.dart';

part 'supabase_favorites_api.chopper.dart';

@ChopperApi()
abstract class SupabaseFavoritesApi extends ChopperService {
  @GET(path: '/favorites')
  Future<Response<dynamic>> getUserFavorites(
    @Query('user_id') String userId,
    @Query('select') String select,
  );

  @POST(path: '/favorites')
  Future<Response<dynamic>> addFavorite(
    @Body() Map<String, dynamic> favorite,
  );

  @DELETE(path: '/favorites')
  Future<Response<dynamic>> removeFavorite(
    @Query('user_id') String userId,
    @Query('place_id') String placeId,
  );

  @GET(path: '/favorites')
  Future<Response<dynamic>> checkIsFavorite(
    @Query('user_id') String userId,
    @Query('place_id') String placeId,
  );

  static SupabaseFavoritesApi create(ChopperClient client) =>
      _$SupabaseFavoritesApi(client);
}
