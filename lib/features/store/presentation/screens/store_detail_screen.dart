import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../product_detail/data/models/review_model.dart';
import '../cubit/store_detail_cubit.dart';
import '../cubit/store_detail_state.dart';

class StoreDetailScreen extends StatelessWidget {
  final String storeId;

  const StoreDetailScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreDetailCubit, StoreDetailState>(
      builder: (context, state) {
        if (state.status == StoreDetailStatus.loading ||
            state.status == StoreDetailStatus.initial) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state.status == StoreDetailStatus.error || state.store == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'Failed to load store'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<StoreDetailCubit>().loadStore(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final store = state.store!;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // Banner
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  leading: IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 16,
                      child: Icon(Icons.arrow_back_ios_new,
                          size: 16, color: AppColors.textPrimary),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: store.bannerUrl ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (c, u, e) => Container(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
                // Store info header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: store.imageUrl ?? '',
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorWidget: (c, u, e) => Container(
                              width: 56,
                              height: 56,
                              color: AppColors.primaryLight,
                              child: const Icon(Icons.store,
                                  color: AppColors.primaryDark),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 14, color: AppColors.ratingStar),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${store.rating?.toStringAsFixed(1) ?? "0.0"} (${store.reviewCount ?? 0})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 36,
                          child: AppButton(
                            text: state.isFollowing
                                ? AppStrings.following
                                : AppStrings.follow,
                            width: 100,
                            height: 36,
                            isOutlined: !state.isFollowing,
                            onPressed: () => context
                                .read<StoreDetailCubit>()
                                .toggleFollow(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tabs
                const SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(),
                ),
              ],
              body: TabBarView(
                children: [
                  _ProductsTab(state: state),
                  _ReviewsTab(state: state),
                  _ContactTab(state: state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate();

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.white,
      child: const TabBar(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        tabs: [
          Tab(text: 'Products'),
          Tab(text: AppStrings.reviews),
          Tab(text: AppStrings.contact),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _ProductsTab extends StatelessWidget {
  final StoreDetailState state;

  const _ProductsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final store = state.store!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Store
          Text(AppStrings.aboutStore,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            store.description ?? '',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Popular Categories chips
          Text('Popular Categories',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Best Selling', 'Food Supplies', 'Others', 'New Arrival']
                .map((c) => Chip(
                      label: Text(c, style: const TextStyle(fontSize: 12)),
                      backgroundColor: AppColors.surface,
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          // All Products
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.allProducts,
                  style: Theme.of(context).textTheme.titleSmall),
              const Text(
                AppStrings.seeAll,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          state.products.isEmpty
              ? const LoadingShimmer(height: 200)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductCard(
                      id: product.id,
                      name: product.name,
                      imageUrl: product.imageUrl,
                      price: product.price,
                      originalPrice: product.originalPrice,
                      rating: product.rating,
                      reviewCount: product.reviewCount,
                      discountPercent: product.discountPercent,
                      onTap: () =>
                          context.push('/product/${product.id}'),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  final StoreDetailState state;

  const _ReviewsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final store = state.store!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary
          Row(
            children: [
              Column(
                children: [
                  Text(
                    store.rating?.toStringAsFixed(1) ?? '0.0',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '/5',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < (store.rating?.round() ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.ratingStar,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(child: _buildRatingBars(state.reviews)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Reviews',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(Icons.filter_list, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          ...state.reviews.map((r) => _ReviewCard(review: r)),
        ],
      ),
    );
  }

  Widget _buildRatingBars(List<ReviewModel> reviews) {
    final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      dist[r.rating.round().clamp(1, 5)] =
          (dist[r.rating.round().clamp(1, 5)] ?? 0) + 1;
    }
    final total = reviews.length;

    return Column(
      children: List.generate(5, (i) {
        final stars = 5 - i;
        final count = dist[stars] ?? 0;
        final ratio = total > 0 ? count / total : 0.0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Text('$stars', style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
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

class _ContactTab extends StatelessWidget {
  final StoreDetailState state;

  const _ContactTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final store = state.store!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 48, color: AppColors.textHint),
                  SizedBox(height: 8),
                  Text(
                    'Map View',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (store.address != null) ...[
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    store.address!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          // Follow
          Text(AppStrings.follow,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          // Social links
          if (store.socialLinks.isNotEmpty)
            Row(
              children: store.socialLinks.entries.map((entry) {
                IconData icon;
                Color color;
                switch (entry.key) {
                  case 'facebook':
                    icon = Icons.facebook;
                    color = const Color(0xFF1877F2);
                  case 'instagram':
                    icon = Icons.camera_alt;
                    color = const Color(0xFFE4405F);
                  case 'youtube':
                    icon = Icons.play_circle_fill;
                    color = const Color(0xFFFF0000);
                  case 'twitter':
                    icon = Icons.alternate_email;
                    color = const Color(0xFF1DA1F2);
                  default:
                    icon = Icons.link;
                    color = AppColors.primary;
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.white, size: 20),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
