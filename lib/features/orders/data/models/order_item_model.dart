class OrderItemModel {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String? variant;

  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.variant,
  });

  double get total => price * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: json['quantity'] as int? ?? 1,
      variant: json['variant'] as String?,
    );
  }
}
