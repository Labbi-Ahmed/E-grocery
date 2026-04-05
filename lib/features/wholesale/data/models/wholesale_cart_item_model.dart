class WholesaleCartItemModel {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double pricePerUnit;
  final int quantity;
  final int minOrderQuantity;
  final String? unit;
  final String? storeName;

  const WholesaleCartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.pricePerUnit,
    required this.quantity,
    this.minOrderQuantity = 10,
    this.unit,
    this.storeName,
  });

  double get total => pricePerUnit * quantity;
  bool get meetsMinOrder => quantity >= minOrderQuantity;

  WholesaleCartItemModel copyWith({int? quantity, double? pricePerUnit}) {
    return WholesaleCartItemModel(
      id: id,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      quantity: quantity ?? this.quantity,
      minOrderQuantity: minOrderQuantity,
      unit: unit,
      storeName: storeName,
    );
  }
}
