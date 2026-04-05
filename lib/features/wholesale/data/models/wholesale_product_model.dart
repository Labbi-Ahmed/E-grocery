class PricingTier {
  final int minQuantity;
  final int? maxQuantity;
  final double pricePerUnit;

  const PricingTier({
    required this.minQuantity,
    this.maxQuantity,
    required this.pricePerUnit,
  });

  String get label {
    if (maxQuantity != null) return '$minQuantity - $maxQuantity units';
    return '$minQuantity+ units';
  }

  factory PricingTier.fromJson(Map<String, dynamic> json) {
    return PricingTier(
      minQuantity: json['min_quantity'] as int? ?? 0,
      maxQuantity: json['max_quantity'] as int?,
      pricePerUnit: (json['price_per_unit'] as num?)?.toDouble() ?? 0,
    );
  }
}

class WholesaleProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> images;
  final double retailPrice;
  final double wholesalePrice;
  final int minOrderQuantity;
  final double? rating;
  final int? reviewCount;
  final String? unit;
  final String? description;
  final String? shippingInfo;
  final Map<String, String> additionalInfo;
  final List<PricingTier> pricingTiers;
  final String? storeName;
  final String? storeId;

  const WholesaleProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.images = const [],
    required this.retailPrice,
    required this.wholesalePrice,
    this.minOrderQuantity = 10,
    this.rating,
    this.reviewCount,
    this.unit,
    this.description,
    this.shippingInfo,
    this.additionalInfo = const {},
    this.pricingTiers = const [],
    this.storeName,
    this.storeId,
  });

  double priceForQuantity(int quantity) {
    for (final tier in pricingTiers.reversed) {
      if (quantity >= tier.minQuantity) return tier.pricePerUnit;
    }
    return wholesalePrice;
  }

  factory WholesaleProductModel.fromJson(Map<String, dynamic> json) {
    return WholesaleProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      retailPrice: (json['retail_price'] as num?)?.toDouble() ?? 0,
      wholesalePrice: (json['wholesale_price'] as num?)?.toDouble() ?? 0,
      minOrderQuantity: json['min_order_quantity'] as int? ?? 10,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      unit: json['unit'] as String?,
      description: json['description'] as String?,
      shippingInfo: json['shipping_info'] as String?,
      additionalInfo: (json['additional_info'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      pricingTiers: (json['pricing_tiers'] as List?)
              ?.map((e) => PricingTier.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      storeName: json['store_name'] as String?,
      storeId: json['store_id']?.toString(),
    );
  }
}
