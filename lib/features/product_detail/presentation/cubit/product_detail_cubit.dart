import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_detail_model.dart';
import '../../data/models/review_model.dart';
import '../../../home/data/models/product_model.dart';
import '../../domain/repositories/product_detail_repository.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailRepository _repository;
  final String productId;

  ProductDetailCubit({
    required ProductDetailRepository repository,
    required this.productId,
  })  : _repository = repository,
        super(const ProductDetailState());

  Future<void> loadProduct() async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    String? error;

    // Load all data in parallel
    final productFuture = _repository.getProductDetail(productId);
    final reviewsFuture = _repository.getReviews(productId);
    final relatedFuture = _repository.getRelatedProducts(productId);

    final productResult = await productFuture;
    final reviewsResult = await reviewsFuture;
    final relatedResult = await relatedFuture;

    productResult.fold(
      (e) => error = e.message,
      (ProductDetailModel product) => emit(state.copyWith(
        product: product,
        selectedVariant: product.selectedVariant ??
            (product.variants.isNotEmpty ? product.variants.first : null),
      )),
    );

    reviewsResult.fold(
      (e) {},
      (List<ReviewModel> reviews) =>
          emit(state.copyWith(reviews: reviews)),
    );

    relatedResult.fold(
      (e) {},
      (List<ProductModel> products) =>
          emit(state.copyWith(relatedProducts: products)),
    );

    if (error != null) {
      emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: error,
      ));
    } else {
      emit(state.copyWith(status: ProductDetailStatus.loaded));
    }
  }

  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void selectVariant(String variant) {
    emit(state.copyWith(selectedVariant: variant));
  }

  void toggleWishlist() {
    emit(state.copyWith(isWishlisted: !state.isWishlisted));
  }

  Future<void> submitReview({
    required double rating,
    required String comment,
  }) async {
    final result = await _repository.submitReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );

    result.fold(
      (e) {},
      (_) => loadProduct(),
    );
  }
}
