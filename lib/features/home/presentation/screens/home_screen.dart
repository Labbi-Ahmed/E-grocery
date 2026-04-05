import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../../data/models/product_model.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_scroll.dart';
import '../widgets/home_shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CartCubit>()),
        BlocProvider.value(value: getIt<WishlistCubit>()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.loading ||
                  state.status == HomeStatus.initial) {
                return const HomeShimmer();
              }

              if (state.status == HomeStatus.error &&
                  state.banners.isEmpty) {
                return _ErrorView(
                  message: state.errorMessage ?? 'Something went wrong',
                  onRetry: () => context.read<HomeCubit>().loadHome(),
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<HomeCubit>().refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(context),
                      _buildSearchBar(context),
                      const SizedBox(height: 20),
                      BannerCarousel(banners: state.banners),
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                        context,
                        AppStrings.categories,
                        () => context.push('/categories'),
                      ),
                      const SizedBox(height: 12),
                      CategoryScroll(
                        categories: state.categories,
                        onCategoryTap: (category) {
                          context.push(
                            '/products/${category.id}',
                            extra: category.name,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                        context,
                        AppStrings.featuredProducts,
                        () {},
                      ),
                      const SizedBox(height: 12),
                      _buildHorizontalProductList(
                        context,
                        state.featuredProducts,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                        context,
                        AppStrings.bestSelling,
                        () {},
                      ),
                      const SizedBox(height: 12),
                      _buildProductGrid(context, state.bestSelling),
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                        context,
                        AppStrings.popularProducts,
                        () {},
                      ),
                      const SizedBox(height: 12),
                      _buildProductGrid(context, state.popularProducts),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver to',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'San Francisco, CA',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => context.push('/search'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.textHint, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  AppStrings.searchHint,
                  style: TextStyle(color: AppColors.textHint, fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onSeeAll,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              AppStrings.seeAll,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, ProductModel product) {
    context.read<CartCubit>().addItem(
          CartItemModel(
            id: 'cart_${product.id}',
            productId: product.id,
            name: product.name,
            imageUrl: product.imageUrl,
            price: product.price,
            originalPrice: product.originalPrice,
            quantity: 1,
            variant: product.unit,
            storeName: product.storeName,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildHorizontalProductList(
    BuildContext context,
    List<ProductModel> products,
  ) {
    return SizedBox(
      height: 250,
      child: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, _) {
          final wishlistCubit = context.read<WishlistCubit>();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return SizedBox(
                width: 160,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    id: product.id,
                    name: product.name,
                    imageUrl: product.imageUrl,
                    price: product.price,
                    originalPrice: product.originalPrice,
                    rating: product.rating,
                    reviewCount: product.reviewCount,
                    discountPercent: product.discountPercent,
                    isWishlisted: wishlistCubit.isWishlisted(product.id),
                    onTap: () => context.push('/product/${product.id}'),
                    onAddToCart: () => _addToCart(context, product),
                    onWishlistToggle: () =>
                        wishlistCubit.toggleItem(product),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(
    BuildContext context,
    List<ProductModel> products,
  ) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, _) {
        final wishlistCubit = context.read<WishlistCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                id: product.id,
                name: product.name,
                imageUrl: product.imageUrl,
                price: product.price,
                originalPrice: product.originalPrice,
                rating: product.rating,
                reviewCount: product.reviewCount,
                discountPercent: product.discountPercent,
                isWishlisted: wishlistCubit.isWishlisted(product.id),
                onTap: () => context.push('/product/${product.id}'),
                onAddToCart: () => _addToCart(context, product),
                onWishlistToggle: () =>
                    wishlistCubit.toggleItem(product),
              );
            },
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
