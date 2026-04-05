class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final int quantity;
  final String? variant;
  final String? storeName;
  final String? storeId;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.quantity = 1,
    this.variant,
    this.storeName,
    this.storeId,
  });

  double get total => price * quantity;

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    double? originalPrice,
    int? quantity,
    String? variant,
    String? storeName,
    String? storeId,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      variant: variant ?? this.variant,
      storeName: storeName ?? this.storeName,
      storeId: storeId ?? this.storeId,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int? ?? 1,
      variant: json['variant'] as String?,
      storeName: json['store_name'] as String?,
      storeId: json['store_id']?.toString(),
    );
  }
}
