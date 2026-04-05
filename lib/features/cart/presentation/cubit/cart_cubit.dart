import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';
import '../../domain/repositories/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(const CartState());

  Future<void> addItem(CartItemModel item) async {
    final existing = state.items.where((i) => i.productId == item.productId);
    List<CartItemModel> updatedItems;
    if (existing.isNotEmpty) {
      updatedItems = state.items.map((i) {
        if (i.productId == item.productId) {
          return i.copyWith(quantity: i.quantity + item.quantity);
        }
        return i;
      }).toList();
    } else {
      updatedItems = [...state.items, item];
    }
    emit(state.copyWith(items: updatedItems, status: CartStatus.loaded));
    await _repository.addItem(item);
  }

  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading));

    final result = await _repository.getCartItems();

    result.fold(
      (error) => emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: error.message,
      )),
      (items) => emit(state.copyWith(
        status: CartStatus.loaded,
        items: items,
      )),
    );
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity < 1) return;

    final updatedItems = state.items.map((item) {
      if (item.id == id) return item.copyWith(quantity: quantity);
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
    await _repository.updateQuantity(id, quantity);
  }

  Future<void> removeItem(String id) async {
    final updatedItems = state.items.where((item) => item.id != id).toList();
    emit(state.copyWith(items: updatedItems));
    await _repository.removeItem(id);
  }

  Future<void> applyCoupon(String code) async {
    final result = await _repository.applyCoupon(code);

    result.fold(
      (error) => emit(state.copyWith(couponError: error.message)),
      (discount) {
        if (discount > 0) {
          emit(state.copyWith(
            discountPercent: discount,
            couponCode: code,
            couponError: null,
          ));
        } else {
          emit(state.copyWith(couponError: 'Invalid coupon code'));
        }
      },
    );
  }
}
