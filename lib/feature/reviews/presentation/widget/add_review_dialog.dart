import 'package:flutter/material.dart';
import 'package:travelspot/generated/l10n/app_localizations.dart';

class AddReviewDialog extends StatefulWidget {
  final String placeId;
  final String placeName;

  const AddReviewDialog({
    super.key,
    required this.placeId,
    required this.placeName,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).reviewPlace(widget.placeName)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).yourRating,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = starValue;
                      });
                    },
                    icon: Icon(
                      starValue <= _rating ? Icons.star : Icons.star_border,
                      color: starValue <= _rating
                          ? Colors.amber.shade700
                          : Colors.grey,
                      size: 40,
                    ),
                  );
                }),
              ),
            ),
            if (_rating > 0) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _getRatingText(_rating),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).commentOptionalLabel,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).shareExperience,
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
              maxLength: 500,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: _rating > 0
              ? () {
                  Navigator.of(context).pop({
                    'rating': _rating,
                    'comment': _commentController.text.trim().isEmpty
                        ? null
                        : _commentController.text.trim(),
                  });
                }
              : null,
          child: Text(AppLocalizations.of(context).ratePlace),
        ),
      ],
    );
  }

  String _getRatingText(int rating) {
    final l10n = AppLocalizations.of(context);
    switch (rating) {
      case 1:
        return l10n.ratingVeryBad;
      case 2:
        return l10n.ratingBad;
      case 3:
        return l10n.ratingRegular;
      case 4:
        return l10n.ratingGood;
      case 5:
        return l10n.ratingExcellent;
      default:
        return '';
    }
  }
}
