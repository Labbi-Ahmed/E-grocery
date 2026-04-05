import '../../../home/data/models/product_model.dart';
import '../../data/models/product_detail_model.dart';
import '../../data/models/review_model.dart';

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductDetailState {
  final ProductDetailStatus status;
  final ProductDetailModel? product;
  final List<ReviewModel> reviews;
  final List<ProductModel> relatedProducts;
  final int quantity;
  final String? selectedVariant;
  final bool isWishlisted;
  final String? errorMessage;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.reviews = const [],
    this.relatedProducts = const [],
    this.quantity = 1,
    this.selectedVariant,
    this.isWishlisted = false,
    this.errorMessage,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductDetailModel? product,
    List<ReviewModel>? reviews,
    List<ProductModel>? relatedProducts,
    int? quantity,
    String? selectedVariant,
    bool? isWishlisted,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      quantity: quantity ?? this.quantity,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
