import '../../data/models/address_model.dart';

enum CheckoutStatus { initial, loading, loaded, placing, placed, error }

class CheckoutState {
  final CheckoutStatus status;
  final List<AddressModel> addresses;
  final String? selectedAddressId;
  final String? selectedPaymentMethod;
  final String? orderId;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.addresses = const [],
    this.selectedAddressId,
    this.selectedPaymentMethod,
    this.orderId,
    this.errorMessage,
  });

  AddressModel? get selectedAddress {
    if (selectedAddressId == null) return null;
    return addresses
        .where((a) => a.id == selectedAddressId)
        .firstOrNull;
  }

  CheckoutState copyWith({
    CheckoutStatus? status,
    List<AddressModel>? addresses,
    String? selectedAddressId,
    String? selectedPaymentMethod,
    String? orderId,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      orderId: orderId ?? this.orderId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
