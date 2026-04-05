import '../../../home/data/models/product_model.dart';

enum WishlistStatus { initial, loading, loaded, error }

class WishlistState {
  final WishlistStatus status;
  final List<ProductModel> items;
  final String? activeSort;
  final String? activeCategory;
  final String searchQuery;
  final String? errorMessage;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.activeSort,
    this.activeCategory,
    this.searchQuery = '',
    this.errorMessage,
  });

  int get itemCount => items.length;

  List<ProductModel> get filteredItems {
    if (searchQuery.isEmpty) return items;
    return items
        .where((item) =>
            item.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  WishlistState copyWith({
    WishlistStatus? status,
    List<ProductModel>? items,
    String? activeSort,
    String? activeCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      activeSort: activeSort ?? this.activeSort,
      activeCategory: activeCategory ?? this.activeCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
