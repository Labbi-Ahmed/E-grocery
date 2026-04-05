import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/wishlist_repository.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _repository;

  WishlistCubit(this._repository) : super(const WishlistState());

  Future<void> loadWishlist() async {
    emit(state.copyWith(status: WishlistStatus.loading));

    final result = await _repository.getWishlist(
      sort: state.activeSort,
      category: state.activeCategory,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: WishlistStatus.error,
        errorMessage: error.message,
      )),
      (items) => emit(state.copyWith(
        status: WishlistStatus.loaded,
        items: items,
      )),
    );
  }

  Future<void> removeItem(String productId) async {
    final updatedItems =
        state.items.where((item) => item.id != productId).toList();
    emit(state.copyWith(items: updatedItems));
    await _repository.removeItem(productId);
  }

  Future<void> changeSort(String? sort) async {
    emit(state.copyWith(activeSort: sort));
    await loadWishlist();
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
