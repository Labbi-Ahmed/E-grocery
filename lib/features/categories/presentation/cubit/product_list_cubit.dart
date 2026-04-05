import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/categories_repository.dart';
import 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final CategoriesRepository _repository;
  final String categoryId;

  ProductListCubit({
    required CategoriesRepository repository,
    required this.categoryId,
  })  : _repository = repository,
        super(const ProductListState());

  Future<void> loadProducts() async {
    emit(state.copyWith(
      status: ProductListStatus.loading,
      currentPage: 1,
      hasReachedEnd: false,
    ));

    final result = await _repository.getCategoryProducts(
      categoryId: categoryId,
      page: 1,
      sort: state.activeSort,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: ProductListStatus.error,
        errorMessage: error.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductListStatus.loaded,
        products: products,
        currentPage: 1,
        hasReachedEnd: products.length < 10,
      )),
    );
  }

  Future<void> loadMore() async {
    if (state.hasReachedEnd ||
        state.status == ProductListStatus.loadingMore) {
      return;
    }

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(status: ProductListStatus.loadingMore));

    final result = await _repository.getCategoryProducts(
      categoryId: categoryId,
      page: nextPage,
      sort: state.activeSort,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: ProductListStatus.loaded,
        errorMessage: error.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductListStatus.loaded,
        products: [...state.products, ...products],
        currentPage: nextPage,
        hasReachedEnd: products.length < 10,
      )),
    );
  }

  Future<void> changeSort(String? sort) async {
    emit(state.copyWith(activeSort: sort));
    await loadProducts();
  }

  void toggleViewMode() {
    emit(state.copyWith(isGridView: !state.isGridView));
  }
}
