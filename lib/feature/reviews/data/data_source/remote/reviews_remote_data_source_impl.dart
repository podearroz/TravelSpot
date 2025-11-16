import 'package:travelspot/feature/reviews/data/data_source/remote/reviews_remote_data_source.dart';
import 'package:travelspot/feature/reviews/data/data_source/remote/supabase_reviews_api.dart';
import 'package:travelspot/feature/reviews/domain/entity/review.dart';

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final SupabaseReviewsApi _api;

  ReviewsRemoteDataSourceImpl(this._api);

  @override
  Future<List<Review>> getPlaceReviews(String placeId) async {
    try {
      final response = await _api.getPlaceReviews(
        'eq.$placeId',
        'id,place_id,author_id,rating,comment,created_at,updated_at',
      );

      print('Reviews API Response - Status: ${response.statusCode}');
      print('Reviews API Response - Body: ${response.body}');

      if (response.isSuccessful && response.body != null) {
        final data = response.body!;

        if (data is List) {
          return data
              .map((json) => Review.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final list = data['data'] as List;
          return list
              .map((json) => Review.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        return [];
      }

      throw Exception('Failed to get reviews: Status ${response.statusCode}');
    } catch (e) {
      print('Error getting reviews: $e');
      throw Exception('Error getting reviews: $e');
    }
  }

  @override
  Future<Review> addReview(
      String placeId, String authorId, int rating, String? comment) async {
    final reviewData = {
      'place_id': placeId,
      'author_id': authorId,
      'rating': rating,
      if (comment != null) 'comment': comment,
    };

    final response = await _api.addReview(reviewData);

    print('Add Review API Response - Status: ${response.statusCode}');
    print('Add Review API Response - Body: ${response.body}');

    if (response.isSuccessful && response.body != null) {
      final data = response.body!;

      if (data is List && data.isNotEmpty) {
        return Review.fromJson(data.first as Map<String, dynamic>);
      }

      if (data is Map<String, dynamic>) {
        if (data.containsKey('data')) {
          final itemData = data['data'];
          if (itemData is List && itemData.isNotEmpty) {
            return Review.fromJson(itemData.first as Map<String, dynamic>);
          } else if (itemData is Map<String, dynamic>) {
            return Review.fromJson(itemData);
          }
        } else {
          return Review.fromJson(data);
        }
      }
    }

    throw Exception('Failed to add review: Status ${response.statusCode}');
  }

  @override
  Future<void> updateReview(
      String reviewId, int rating, String? comment) async {
    final updates = {
      'rating': rating,
      if (comment != null) 'comment': comment,
    };

    final response = await _api.updateReview('eq.$reviewId', updates);

    print('Update Review API Response - Status: ${response.statusCode}');

    if (!response.isSuccessful) {
      throw Exception('Failed to update review: Status ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    final response = await _api.deleteReview('eq.$reviewId');

    print('Delete Review API Response - Status: ${response.statusCode}');

    if (!response.isSuccessful) {
      throw Exception('Failed to delete review: Status ${response.statusCode}');
    }
  }

  @override
  Future<Review?> getUserReviewForPlace(String placeId, String userId) async {
    try {
      final response =
          await _api.getUserReviewForPlace('eq.$placeId', 'eq.$userId');

      print('Get User Review API Response - Status: ${response.statusCode}');

      if (response.isSuccessful && response.body != null) {
        final data = response.body!;

        if (data is List && data.isNotEmpty) {
          return Review.fromJson(data.first as Map<String, dynamic>);
        }

        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final list = data['data'] as List;
          if (list.isNotEmpty) {
            return Review.fromJson(list.first as Map<String, dynamic>);
          }
        }
      }

      return null;
    } catch (e) {
      print('Error getting user review: $e');
      return null;
    }
  }
}
