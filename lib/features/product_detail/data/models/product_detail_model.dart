class ProductDetailModel {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> images;
  final double price;
  final double? originalPrice;
  final double? rating;
  final int? reviewCount;
  final int? discountPercent;
  final String? unit;
  final String? description;
  final String? shippingInfo;
  final Map<String, String> additionalInfo;
  final String? storeId;
  final String? storeName;
  final String? storeImage;
  final double? storeRating;
  final List<String> variants;
  final String? selectedVariant;

  const ProductDetailModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.images = const [],
    required this.price,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    this.discountPercent,
    this.unit,
    this.description,
    this.shippingInfo,
    this.additionalInfo = const {},
    this.storeId,
    this.storeName,
    this.storeImage,
    this.storeRating,
    this.variants = const [],
    this.selectedVariant,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: (json['price'] as num?)?.toDouble() ?? 0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      discountPercent: json['discount_percent'] as int?,
      unit: json['unit'] as String?,
      description: json['description'] as String?,
      shippingInfo: json['shipping_info'] as String?,
      additionalInfo:
          (json['additional_info'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, v.toString()),
              ) ??
              {},
      storeId: json['store_id']?.toString(),
      storeName: json['store_name'] as String?,
      storeImage: json['store_image'] as String?,
      storeRating: (json['store_rating'] as num?)?.toDouble(),
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
