import '../../../home/data/models/product_model.dart';

enum ProductListStatus { initial, loading, loaded, loadingMore, error }

class ProductListState {
  final ProductListStatus status;
  final List<ProductModel> products;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedEnd;
  final String? activeSort;
  final bool isGridView;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedEnd = false,
    this.activeSort,
    this.isGridView = true,
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedEnd,
    String? activeSort,
    bool? isGridView,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      activeSort: activeSort ?? this.activeSort,
      isGridView: isGridView ?? this.isGridView,
    );
  }
}
