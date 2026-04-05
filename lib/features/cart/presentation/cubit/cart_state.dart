import '../../data/models/cart_item_model.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState {
  final CartStatus status;
  final List<CartItemModel> items;
  final double discountPercent;
  final String? couponCode;
  final String? errorMessage;
  final String? couponError;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.discountPercent = 0,
    this.couponCode,
    this.errorMessage,
    this.couponError,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get shipping => subtotal > 50 ? 0 : 10.0;
  double get discount => subtotal * discountPercent / 100;
  double get total => subtotal + shipping - discount;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, List<CartItemModel>> get groupedByStore {
    final map = <String, List<CartItemModel>>{};
    for (final item in items) {
      final store = item.storeName ?? 'Other';
      map.putIfAbsent(store, () => []).add(item);
    }
    return map;
  }

  CartState copyWith({
    CartStatus? status,
    List<CartItemModel>? items,
    double? discountPercent,
    String? couponCode,
    String? errorMessage,
    String? couponError,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      discountPercent: discountPercent ?? this.discountPercent,
      couponCode: couponCode ?? this.couponCode,
      errorMessage: errorMessage ?? this.errorMessage,
      couponError: couponError,
    );
  }
}
