import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelspot/generated/l10n/app_localizations.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_state.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_bloc.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_event.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_state.dart';
import 'package:travelspot/feature/reviews/presentation/widget/add_review_dialog.dart';

class ReviewsModal extends StatelessWidget {
  final String placeId;
  final String placeName;

  const ReviewsModal({
    super.key,
    required this.placeId,
    required this.placeName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ReviewsBloc>(context)
        ..add(LoadPlaceReviewsEvent(placeId)),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).reviewsOf(placeName),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: BlocBuilder<ReviewsBloc, ReviewsState>(
                    builder: (context, state) {
                      if (state is ReviewsLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is ReviewsErrorState) {
                        return Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .reviewsError(state.message),
                                style: const TextStyle(color: Colors.red)));
                      }
                      if (state is ReviewsLoadedState) {
                        if (state.reviews.isEmpty) {
                          return Center(
                              child: Text(
                                  AppLocalizations.of(context).noReviewsYet));
                        }
                        return ListView.separated(
                          controller: scrollController,
                          itemCount: state.reviews.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final review = state.reviews[index];
                            return ListTile(
                              leading: Icon(Icons.star,
                                  color: Colors.amber.shade700),
                              title: Row(
                                children: [
                                  Text('${review.rating}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  if (review.comment != null &&
                                      review.comment!.isNotEmpty)
                                    Expanded(child: Text(review.comment!)),
                                ],
                              ),
                              subtitle: Text(AppLocalizations.of(context)
                                  .reviewBy(review.authorId)),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.rate_review),
                    label: Text(AppLocalizations.of(context).ratePlace),
                    onPressed: () async {
                      // Checagem explícita de autenticação antes de abrir o modal
                      final authState = context.read<AuthBloc>().state;
                      String? userId;
                      if (authState is AuthAuthenticated) {
                        userId = authState.user.id;
                      }
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context).needsAuthToReview),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (context) => AddReviewDialog(
                          placeId: placeId,
                          placeName: placeName,
                        ),
                      );
                      if (result != null && result['rating'] != null) {
                        BlocProvider.of<ReviewsBloc>(context).add(
                          AddReviewEvent(
                            placeId: placeId,
                            authorId: userId,
                            rating: result['rating'],
                            comment: result['comment'],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
