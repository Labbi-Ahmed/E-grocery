class StoreModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? bannerUrl;
  final double? rating;
  final int? reviewCount;
  final int? productCount;
  final String? description;
  final String? address;
  final String? phone;
  final bool isFollowing;
  final Map<String, String> socialLinks;

  const StoreModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.bannerUrl,
    this.rating,
    this.reviewCount,
    this.productCount,
    this.description,
    this.address,
    this.phone,
    this.isFollowing = false,
    this.socialLinks = const {},
  });

  StoreModel copyWith({bool? isFollowing}) {
    return StoreModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      bannerUrl: bannerUrl,
      rating: rating,
      reviewCount: reviewCount,
      productCount: productCount,
      description: description,
      address: address,
      phone: phone,
      isFollowing: isFollowing ?? this.isFollowing,
      socialLinks: socialLinks,
    );
  }

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      productCount: json['product_count'] as int?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      isFollowing: json['is_following'] as bool? ?? false,
      socialLinks: (json['social_links'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
    );
  }
}
