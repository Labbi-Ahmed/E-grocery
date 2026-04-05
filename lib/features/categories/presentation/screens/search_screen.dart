import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/empty_state_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchCubit>().loadMore();
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<SearchCubit>().updateSuggestions(query);
    });
  }

  void _onSearchSubmitted(String query) {
    _debounce?.cancel();
    if (query.trim().isNotEmpty) {
      _focusNode.unfocus();
      context.read<SearchCubit>().search(query.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: _buildSearchField(),
        titleSpacing: 0,
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // Show suggestions if typing
          if (state.suggestions.isNotEmpty &&
              state.status != SearchStatus.loaded) {
            return _buildSuggestions(state);
          }

          // Show results
          if (state.status == SearchStatus.loading) {
            return const ProductGridShimmer(itemCount: 6);
          }

          if (state.status == SearchStatus.loaded) {
            if (state.results.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.search_off,
                title: 'Not Found',
                subtitle:
                    'Sorry, the keyword you entered cannot be found. Please try another keyword.',
              );
            }
            return _buildResults(state);
          }

          if (state.status == SearchStatus.error) {
            return EmptyStateWidget(
              title: 'Search failed',
              subtitle: state.errorMessage,
              buttonText: 'Retry',
              onButtonPressed: () =>
                  context.read<SearchCubit>().search(state.query),
            );
          }

          // Initial state - show recent searches
          return _buildRecentSearches(state);
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 42,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _onSearchChanged,
        onSubmitted: _onSearchSubmitted,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: const TextStyle(
            color: AppColors.textHint,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textHint,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchCubit>().updateSuggestions('');
                    _focusNode.requestFocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(SearchState state) {
    if (state.recentSearches.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history,
        title: 'Search for products',
        subtitle: 'Find your favorite African groceries',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            GestureDetector(
              onTap: () => context.read<SearchCubit>().clearRecentSearches(),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...state.recentSearches.map((query) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.history,
                color: AppColors.textHint,
                size: 20,
              ),
              title: Text(query, style: const TextStyle(fontSize: 14)),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () =>
                    context.read<SearchCubit>().removeRecentSearch(query),
              ),
              onTap: () {
                _searchController.text = query;
                _onSearchSubmitted(query);
              },
            )),
      ],
    );
  }

  Widget _buildSuggestions(SearchState state) {
    return ListView.builder(
      itemCount: state.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, color: AppColors.textHint, size: 20),
          title: Text(suggestion, style: const TextStyle(fontSize: 14)),
          trailing: const Icon(
            Icons.north_west,
            color: AppColors.textHint,
            size: 16,
          ),
          onTap: () {
            _searchController.text = suggestion;
            _onSearchSubmitted(suggestion);
          },
        );
      },
    );
  }

  Widget _buildResults(SearchState state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final product = state.results[index];
        return ProductCard(
          id: product.id,
          name: product.name,
          imageUrl: product.imageUrl,
          price: product.price,
          originalPrice: product.originalPrice,
          rating: product.rating,
          reviewCount: product.reviewCount,
          discountPercent: product.discountPercent,
          onTap: () => context.push('/product/${product.id}'),
          onAddToCart: () {},
          onWishlistToggle: () {},
        );
      },
    );
  }
}
