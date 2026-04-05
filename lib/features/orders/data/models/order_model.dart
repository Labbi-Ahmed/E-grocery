import 'order_item_model.dart';

enum OrderStatus { processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String orderNumber;
  final List<OrderItemModel> items;
  final double subtotal;
  final double shipping;
  final double discount;
  final double total;
  final OrderStatus status;
  final String date;
  final String? address;
  final List<TrackingStep> trackingSteps;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.shipping,
    this.discount = 0,
    required this.total,
    required this.status,
    required this.date,
    this.address,
    this.trackingSteps = const [],
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.processing:
        return 'In Progress';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      shipping: (json['shipping'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.processing,
      ),
      date: json['date'] as String? ?? '',
      address: json['address'] as String?,
      trackingSteps: (json['tracking_steps'] as List<dynamic>?)
              ?.map((e) => TrackingStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TrackingStep {
  final String title;
  final String? subtitle;
  final String? date;
  final bool isCompleted;

  const TrackingStep({
    required this.title,
    this.subtitle,
    this.date,
    this.isCompleted = false,
  });

  factory TrackingStep.fromJson(Map<String, dynamic> json) {
    return TrackingStep(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      date: json['date'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }
}
