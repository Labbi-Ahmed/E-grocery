import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/review_model.dart';

class ReviewSection extends StatelessWidget {
  final List<ReviewModel> reviews;
  final double? averageRating;
  final int? totalReviews;
  final VoidCallback? onWriteReview;

  const ReviewSection({
    super.key,
    required this.reviews,
    this.averageRating,
    this.totalReviews,
    this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onWriteReview != null)
              GestureDetector(
                onTap: onWriteReview,
                child: const Text(
                  'Write a Review',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (averageRating != null) _buildRatingSummary(),
        const SizedBox(height: 16),
        ...reviews.map((review) => _ReviewCard(review: review)),
      ],
    );
  }

  Widget _buildRatingSummary() {
    final rating = averageRating ?? 0;
    return Row(
      children: [
        Column(
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: List.generate(5, (i) {
                return Icon(
                  i < rating.round() ? Icons.star : Icons.star_border,
                  color: AppColors.ratingStar,
                  size: 16,
                );
              }),
            ),
            const SizedBox(height: 4),
            Text(
              '${totalReviews ?? 0} reviews',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(child: _buildRatingBars()),
      ],
    );
  }

  Widget _buildRatingBars() {
    final distribution = _calculateDistribution();
    final total = reviews.length;

    return Column(
      children: List.generate(5, (i) {
        final stars = 5 - i;
        final count = distribution[stars] ?? 0;
        final ratio = total > 0 ? count / total : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Text(
                '$stars',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 12, color: AppColors.ratingStar),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: AppColors.surface,
                    color: AppColors.ratingStar,
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Map<int, int> _calculateDistribution() {
    final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in reviews) {
      final stars = review.rating.round().clamp(1, 5);
      dist[stars] = (dist[stars] ?? 0) + 1;
    }
    return dist;
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      review.date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: AppColors.ratingStar,
                    size: 14,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
