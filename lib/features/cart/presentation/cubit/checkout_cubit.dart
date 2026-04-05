import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/address_model.dart';
import '../../domain/repositories/cart_repository.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CartRepository _repository;

  CheckoutCubit(this._repository) : super(const CheckoutState());

  Future<void> loadAddresses() async {
    emit(state.copyWith(status: CheckoutStatus.loading));

    final result = await _repository.getAddresses();

    result.fold(
      (error) => emit(state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: error.message,
      )),
      (addresses) {
        final defaultAddress =
            addresses.where((a) => a.isDefault).firstOrNull;
        emit(state.copyWith(
          status: CheckoutStatus.loaded,
          addresses: addresses,
          selectedAddressId: defaultAddress?.id ?? addresses.firstOrNull?.id,
        ));
      },
    );
  }

  void selectAddress(String id) {
    emit(state.copyWith(selectedAddressId: id));
  }

  void selectPaymentMethod(String method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  Future<void> addAddress(AddressModel address) async {
    await _repository.addAddress(address);
    await loadAddresses();
  }

  Future<void> placeOrder() async {
    emit(state.copyWith(status: CheckoutStatus.placing));

    final result = await _repository.placeOrder();

    result.fold(
      (error) => emit(state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: error.message,
      )),
      (orderId) => emit(state.copyWith(
        status: CheckoutStatus.placed,
        orderId: orderId,
      )),
    );
  }
}
