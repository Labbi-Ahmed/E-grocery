import '../../data/models/order_model.dart';

enum OrdersStatus { initial, loading, loaded, error }

class OrdersState {
  final OrdersStatus status;
  final List<OrderModel> orders;
  final String activeTab;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.activeTab = 'active',
    this.errorMessage,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderModel>? orders,
    String? activeTab,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      activeTab: activeTab ?? this.activeTab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
