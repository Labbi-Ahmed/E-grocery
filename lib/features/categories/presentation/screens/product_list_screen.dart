import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../home/data/models/product_model.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../cubit/product_list_cubit.dart';
import '../cubit/product_list_state.dart';
import '../widgets/empty_state_widget.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductListCubit>().loadMore();
    }
  }

  void _addToCart(BuildContext context, ProductModel product) {
    getIt<CartCubit>().addItem(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSortChips(),
          Expanded(
            child: BlocBuilder<ProductListCubit, ProductListState>(
              builder: (context, state) {
                if (state.status == ProductListStatus.loading ||
                    state.status == ProductListStatus.initial) {
                  return const ProductGridShimmer(itemCount: 6);
                }

                if (state.status == ProductListStatus.error &&
                    state.products.isEmpty) {
                  return EmptyStateWidget(
                    title: 'Failed to load products',
                    subtitle: state.errorMessage,
                    buttonText: 'Retry',
                    onButtonPressed: () =>
                        context.read<ProductListCubit>().loadProducts(),
                  );
                }

                if (state.products.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No products found',
                    subtitle: 'Try a different category or filter',
                  );
                }

                return _buildProductList(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChips() {
    return BlocBuilder<ProductListCubit, ProductListState>(
      buildWhen: (prev, curr) =>
          prev.activeSort != curr.activeSort ||
          prev.isGridView != curr.isGridView,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _SortChip(
                        label: 'All',
                        isSelected: state.activeSort == null,
                        onTap: () =>
                            context.read<ProductListCubit>().changeSort(null),
                      ),
                      _SortChip(
                        label: 'Popular',
                        isSelected: state.activeSort == 'rating',
                        onTap: () => context
                            .read<ProductListCubit>()
                            .changeSort('rating'),
                      ),
                      _SortChip(
                        label: 'Newest',
                        isSelected: state.activeSort == 'newest',
                        onTap: () => context
                            .read<ProductListCubit>()
                            .changeSort('newest'),
                      ),
                      _SortChip(
                        label: 'Price Low',
                        isSelected: state.activeSort == 'price_low',
                        onTap: () => context
                            .read<ProductListCubit>()
                            .changeSort('price_low'),
                      ),
                      _SortChip(
                        label: 'Price High',
                        isSelected: state.activeSort == 'price_high',
                        onTap: () => context
                            .read<ProductListCubit>()
                            .changeSort('price_high'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () =>
                    context.read<ProductListCubit>().toggleViewMode(),
                child: Icon(
                  state.isGridView ? Icons.grid_view : Icons.view_list,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductList(BuildContext context, ProductListState state) {
    if (state.isGridView) {
      return GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: state.products.length +
            (state.status == ProductListStatus.loadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= state.products.length) {
            return const ProductCardShimmer();
          }
          final product = state.products[index];
          final wishlistCubit = getIt<WishlistCubit>();
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
            onWishlistToggle: () => wishlistCubit.toggleItem(product),
          );
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.products.length +
          (state.status == ProductListStatus.loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final product = state.products[index];
        final wishlistCubit = getIt<WishlistCubit>();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            height: 230,
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
              onWishlistToggle: () => wishlistCubit.toggleItem(product),
            ),
          ),
        );
      },
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
