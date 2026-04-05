import '../../data/models/wholesale_product_model.dart';
import '../../data/models/wholesale_cart_item_model.dart';

enum WholesaleStatus { initial, loading, loaded, error }

class WholesaleState {
  final WholesaleStatus status;
  final List<WholesaleProductModel> products;
  final WholesaleProductModel? selectedProduct;
  final List<WholesaleCartItemModel> cartItems;
  final int detailQuantity;
  final String? errorMessage;

  const WholesaleState({
    this.status = WholesaleStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.cartItems = const [],
    this.detailQuantity = 10,
    this.errorMessage,
  });

  double get cartSubtotal =>
      cartItems.fold(0, (sum, item) => sum + item.total);
  double get cartShipping => cartSubtotal > 500 ? 0 : 25.0;
  double get cartTotal => cartSubtotal + cartShipping;
  bool get allMeetMinOrder => cartItems.every((item) => item.meetsMinOrder);

  WholesaleState copyWith({
    WholesaleStatus? status,
    List<WholesaleProductModel>? products,
    WholesaleProductModel? selectedProduct,
    List<WholesaleCartItemModel>? cartItems,
    int? detailQuantity,
    String? errorMessage,
  }) {
    return WholesaleState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      cartItems: cartItems ?? this.cartItems,
      detailQuantity: detailQuantity ?? this.detailQuantity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
