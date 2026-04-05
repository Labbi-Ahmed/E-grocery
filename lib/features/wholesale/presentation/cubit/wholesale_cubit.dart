import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/wholesale_repository.dart';
import 'wholesale_state.dart';

class WholesaleCubit extends Cubit<WholesaleState> {
  final WholesaleRepository _repository;

  WholesaleCubit(this._repository) : super(const WholesaleState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: WholesaleStatus.loading));

    final result = await _repository.getProducts();

    result.fold(
      (error) => emit(state.copyWith(
        status: WholesaleStatus.error,
        errorMessage: error.message,
      )),
      (products) => emit(state.copyWith(
        status: WholesaleStatus.loaded,
        products: products,
      )),
    );
  }

  Future<void> loadProductDetail(String id) async {
    emit(state.copyWith(status: WholesaleStatus.loading));

    final result = await _repository.getProductDetail(id);

    result.fold(
      (error) => emit(state.copyWith(
        status: WholesaleStatus.error,
        errorMessage: error.message,
      )),
      (product) => emit(state.copyWith(
        status: WholesaleStatus.loaded,
        selectedProduct: product,
        detailQuantity: product.minOrderQuantity,
      )),
    );
  }

  void setDetailQuantity(int quantity) {
    final product = state.selectedProduct;
    if (product == null) return;
    if (quantity < product.minOrderQuantity) return;
    emit(state.copyWith(detailQuantity: quantity));
  }

  Future<void> loadCart() async {
    final result = await _repository.getCartItems();

    result.fold(
      (error) {},
      (items) => emit(state.copyWith(cartItems: items)),
    );
  }

  Future<void> updateCartQuantity(String id, int quantity) async {
    final updatedItems = state.cartItems.map((item) {
      if (item.id == id) return item.copyWith(quantity: quantity);
      return item;
    }).toList();
    emit(state.copyWith(cartItems: updatedItems));
    await _repository.updateQuantity(id, quantity);
  }

  Future<void> removeCartItem(String id) async {
    final updatedItems =
        state.cartItems.where((item) => item.id != id).toList();
    emit(state.copyWith(cartItems: updatedItems));
    await _repository.removeItem(id);
  }
}
