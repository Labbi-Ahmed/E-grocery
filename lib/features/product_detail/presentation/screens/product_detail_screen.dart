import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../home/data/models/product_model.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/review_section.dart';
import '../widgets/write_review_sheet.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.details),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  getIt<WishlistCubit>().isWishlisted(productId)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: getIt<WishlistCubit>().isWishlisted(productId)
                      ? AppColors.error
                      : null,
                ),
                onPressed: () {
                  final product = state.product;
                  if (product != null) {
                    getIt<WishlistCubit>().toggleItem(
                      ProductModel(
                        id: product.id,
                        name: product.name,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        originalPrice: product.originalPrice,
                        rating: product.rating,
                        reviewCount: product.reviewCount,
                        discountPercent: product.discountPercent,
                        unit: product.unit,
                        storeName: product.storeName,
                      ),
                    );
                    context.read<ProductDetailCubit>().toggleWishlist();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: _buildBody(context, state),
          bottomNavigationBar: state.product != null
              ? _buildBottomBar(context, state)
              : null,
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductDetailState state) {
    if (state.status == ProductDetailStatus.loading ||
        state.status == ProductDetailStatus.initial) {
      return const _DetailShimmer();
    }

    if (state.status == ProductDetailStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(state.errorMessage ?? 'Failed to load product'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<ProductDetailCubit>().loadProduct(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final product = state.product!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImageGallery(
            images: product.images,
            fallbackImage: product.imageUrl,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (product.unit != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    product.unit!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 8),

                // Price + quantity
                Row(
                  children: [
                    Text(
                      product.price.toCurrency,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    if (product.originalPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        product.originalPrice!.toCurrency,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textHint,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    const Spacer(),
                    QuantitySelector(
                      quantity: state.quantity,
                      onIncrement: () =>
                          context.read<ProductDetailCubit>().incrementQuantity(),
                      onDecrement: () =>
                          context.read<ProductDetailCubit>().decrementQuantity(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Rating
                if (product.rating != null)
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < product.rating!.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.ratingStar,
                          size: 16,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        product.rating!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (product.reviewCount != null)
                        Text(
                          '  (${product.reviewCount} reviews)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                    ],
                  ),

                // Variants
                if (product.variants.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: product.variants.map((variant) {
                      final isSelected = variant == state.selectedVariant;
                      return GestureDetector(
                        onTap: () => context
                            .read<ProductDetailCubit>()
                            .selectVariant(variant),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(color: AppColors.divider),
                          ),
                          child: Text(
                            variant,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Store info
                if (product.storeName != null) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      if (product.storeId != null) {
                        context.push('/store/${product.storeId}');
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product.storeName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        if (product.storeRating != null) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.star,
                              size: 14, color: AppColors.ratingStar),
                          const SizedBox(width: 2),
                          Text(
                            product.storeRating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const Spacer(),
                        const Text(
                          'Visit Store',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios,
                            size: 12, color: AppColors.primary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                ],

                // Description
                if (product.description != null) ...[
                  const SizedBox(height: 16),
                  _ExpandableSection(
                    title: AppStrings.description,
                    content: product.description!,
                  ),
                ],

                // Shipping
                if (product.shippingInfo != null) ...[
                  const SizedBox(height: 12),
                  _ExpandableSection(
                    title: AppStrings.shippingInfo,
                    content: product.shippingInfo!,
                  ),
                ],

                // Additional Info
                if (product.additionalInfo.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.additionalInfo,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...product.additionalInfo.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                // Reviews
                const SizedBox(height: 24),
                ReviewSection(
                  reviews: state.reviews,
                  averageRating: product.rating,
                  totalReviews: product.reviewCount,
                  onWriteReview: () => _showWriteReview(context),
                ),

                // Related Products header
                if (state.relatedProducts.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.relatedProducts,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),

          // Related products scroll
          if (state.relatedProducts.isNotEmpty)
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.relatedProducts.length,
                itemBuilder: (context, index) {
                  final related = state.relatedProducts[index];
                  return SizedBox(
                    width: 160,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ProductCard(
                        id: related.id,
                        name: related.name,
                        imageUrl: related.imageUrl,
                        price: related.price,
                        originalPrice: related.originalPrice,
                        rating: related.rating,
                        reviewCount: related.reviewCount,
                        discountPercent: related.discountPercent,
                        isWishlisted: getIt<WishlistCubit>().isWishlisted(related.id),
                        onTap: () =>
                            context.push('/product/${related.id}'),
                        onAddToCart: () {
                          getIt<CartCubit>().addItem(
                            CartItemModel(
                              id: 'cart_${related.id}',
                              productId: related.id,
                              name: related.name,
                              imageUrl: related.imageUrl,
                              price: related.price,
                              originalPrice: related.originalPrice,
                              quantity: 1,
                              storeName: related.storeName,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${related.name} added to cart'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onWishlistToggle: () =>
                            getIt<WishlistCubit>().toggleItem(related),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductDetailState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: AppButton(
          text: AppStrings.addToCart,
          onPressed: () {
            final product = state.product!;
            getIt<CartCubit>().addItem(
              CartItemModel(
                id: 'cart_${product.id}_${DateTime.now().millisecondsSinceEpoch}',
                productId: product.id,
                name: product.name,
                imageUrl: product.imageUrl,
                price: product.price,
                originalPrice: product.originalPrice,
                quantity: state.quantity,
                variant: state.selectedVariant,
                storeName: product.storeName,
                storeId: product.storeId,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${state.quantity}x ${product.name} added to cart',
                ),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showWriteReview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => WriteReviewSheet(
        onSubmit: (rating, comment) {
          context.read<ProductDetailCubit>().submitReview(
                rating: rating,
                comment: comment,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Review submitted!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}

class _ExpandableSection extends StatefulWidget {
  final String title;
  final String content;

  const _ExpandableSection({required this.title, required this.content});

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 8),
          Text(
            widget.content,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingShimmer(height: 300, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoadingShimmer(height: 24, width: 200),
                const SizedBox(height: 8),
                const LoadingShimmer(height: 14, width: 80),
                const SizedBox(height: 12),
                const LoadingShimmer(height: 24, width: 120),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(
                    4,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: LoadingShimmer(
                        height: 36,
                        width: 60,
                        borderRadius: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const LoadingShimmer(height: 16, width: 100),
                const SizedBox(height: 8),
                const LoadingShimmer(height: 60),
                const SizedBox(height: 16),
                const LoadingShimmer(height: 16, width: 100),
                const SizedBox(height: 8),
                const LoadingShimmer(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
