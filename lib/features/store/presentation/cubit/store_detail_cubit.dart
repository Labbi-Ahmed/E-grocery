import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/models/product_model.dart';
import '../../../product_detail/data/models/review_model.dart';
import '../../data/models/store_model.dart';
import '../../domain/repositories/store_repository.dart';
import 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  final StoreRepository _repository;
  final String storeId;

  StoreDetailCubit({
    required StoreRepository repository,
    required this.storeId,
  })  : _repository = repository,
        super(const StoreDetailState());

  Future<void> loadStore() async {
    emit(state.copyWith(status: StoreDetailStatus.loading));

    final storeFuture = _repository.getStoreDetail(storeId);
    final productsFuture = _repository.getStoreProducts(storeId);
    final reviewsFuture = _repository.getStoreReviews(storeId);

    final storeResult = await storeFuture;
    final productsResult = await productsFuture;
    final reviewsResult = await reviewsFuture;

    String? error;

    storeResult.fold(
      (e) => error = e.message,
      (StoreModel store) => emit(state.copyWith(
        store: store,
        isFollowing: store.isFollowing,
      )),
    );

    productsResult.fold(
      (e) {},
      (List<ProductModel> products) =>
          emit(state.copyWith(products: products)),
    );

    reviewsResult.fold(
      (e) {},
      (List<ReviewModel> reviews) =>
          emit(state.copyWith(reviews: reviews)),
    );

    if (error != null) {
      emit(state.copyWith(
        status: StoreDetailStatus.error,
        errorMessage: error,
      ));
    } else {
      emit(state.copyWith(status: StoreDetailStatus.loaded));
    }
  }

  void toggleFollow() {
    emit(state.copyWith(isFollowing: !state.isFollowing));
  }
}
