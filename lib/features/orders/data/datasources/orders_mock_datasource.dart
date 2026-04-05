import '../models/order_model.dart';
import '../models/order_item_model.dart';

class OrdersMockDatasource {
  Future<List<OrderModel>> getOrders({String? status}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (status == 'completed') return [_orders[2]];
    if (status == 'cancelled') return [_orders[3]];
    if (status == 'active') return [_orders[0], _orders[1]];
    return _orders;
  }

  Future<OrderModel> getOrderDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _orders.firstWhere((o) => o.id == id, orElse: () => _orders.first);
  }

  static final _orders = [
    const OrderModel(
      id: 'ord1',
      orderNumber: 'ORD-20260401001',
      items: [
        OrderItemModel(id: 'oi1', productId: '2', name: 'Chicken Sharma', imageUrl: 'https://via.placeholder.com/100x100/FFCCBC/212121?text=Chicken', price: 140.00, quantity: 2, variant: '1kg'),
        OrderItemModel(id: 'oi2', productId: '5', name: 'Palm Oil', imageUrl: 'https://via.placeholder.com/100x100/FFE0B2/212121?text=Palm+Oil', price: 45.00, quantity: 1, variant: '1L'),
      ],
      subtotal: 325.00,
      shipping: 0,
      discount: 32.50,
      total: 292.50,
      status: OrderStatus.processing,
      date: 'Apr 01, 2026',
      address: '384 Westheimer Rd, San Francisco, CA 94102',
      trackingSteps: [
        TrackingStep(title: 'Order Placed', subtitle: 'Your order has been placed', date: 'Apr 01, 2026', isCompleted: true),
        TrackingStep(title: 'Processing', subtitle: 'Your order is being prepared', date: 'Apr 01, 2026', isCompleted: true),
        TrackingStep(title: 'Shipped', subtitle: 'Your order is on the way'),
        TrackingStep(title: 'Delivered', subtitle: 'Your order has been delivered'),
      ],
    ),
    const OrderModel(
      id: 'ord2',
      orderNumber: 'ORD-20260330002',
      items: [
        OrderItemModel(id: 'oi3', productId: '10', name: 'Suya Spice Mix', imageUrl: 'https://via.placeholder.com/100x100/FFCCBC/212121?text=Suya', price: 15.00, quantity: 3, variant: '200g'),
      ],
      subtotal: 45.00,
      shipping: 10.00,
      total: 55.00,
      status: OrderStatus.shipped,
      date: 'Mar 30, 2026',
      address: '384 Westheimer Rd, San Francisco, CA 94102',
      trackingSteps: [
        TrackingStep(title: 'Order Placed', date: 'Mar 30, 2026', isCompleted: true),
        TrackingStep(title: 'Processing', date: 'Mar 30, 2026', isCompleted: true),
        TrackingStep(title: 'Shipped', subtitle: 'Out for delivery', date: 'Mar 31, 2026', isCompleted: true),
        TrackingStep(title: 'Delivered'),
      ],
    ),
    const OrderModel(
      id: 'ord3',
      orderNumber: 'ORD-20260325003',
      items: [
        OrderItemModel(id: 'oi4', productId: '6', name: 'Cassava Flour', imageUrl: 'https://via.placeholder.com/100x100/FFF9C4/212121?text=Cassava', price: 18.00, quantity: 2, variant: '1kg'),
      ],
      subtotal: 36.00,
      shipping: 10.00,
      total: 46.00,
      status: OrderStatus.delivered,
      date: 'Mar 25, 2026',
      address: '384 Westheimer Rd, San Francisco, CA 94102',
      trackingSteps: [
        TrackingStep(title: 'Order Placed', date: 'Mar 25, 2026', isCompleted: true),
        TrackingStep(title: 'Processing', date: 'Mar 25, 2026', isCompleted: true),
        TrackingStep(title: 'Shipped', date: 'Mar 26, 2026', isCompleted: true),
        TrackingStep(title: 'Delivered', date: 'Mar 27, 2026', isCompleted: true),
      ],
    ),
    const OrderModel(
      id: 'ord4',
      orderNumber: 'ORD-20260320004',
      items: [
        OrderItemModel(id: 'oi5', productId: '9', name: 'Dried Stockfish', imageUrl: 'https://via.placeholder.com/100x100/FFCCBC/212121?text=Stockfish', price: 85.00, quantity: 1, variant: '500g'),
      ],
      subtotal: 85.00,
      shipping: 0,
      total: 85.00,
      status: OrderStatus.cancelled,
      date: 'Mar 20, 2026',
    ),
  ];
}
