import '../../../home/data/models/product_model.dart';
import '../../../product_detail/data/models/review_model.dart';
import '../../data/models/store_model.dart';

enum StoreDetailStatus { initial, loading, loaded, error }

class StoreDetailState {
  final StoreDetailStatus status;
  final StoreModel? store;
  final List<ProductModel> products;
  final List<ReviewModel> reviews;
  final bool isFollowing;
  final String? errorMessage;

  const StoreDetailState({
    this.status = StoreDetailStatus.initial,
    this.store,
    this.products = const [],
    this.reviews = const [],
    this.isFollowing = false,
    this.errorMessage,
  });

  StoreDetailState copyWith({
    StoreDetailStatus? status,
    StoreModel? store,
    List<ProductModel>? products,
    List<ReviewModel>? reviews,
    bool? isFollowing,
    String? errorMessage,
  }) {
    return StoreDetailState(
      status: status ?? this.status,
      store: store ?? this.store,
      products: products ?? this.products,
      reviews: reviews ?? this.reviews,
      isFollowing: isFollowing ?? this.isFollowing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
