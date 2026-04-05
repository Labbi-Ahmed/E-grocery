class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? iconUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.iconUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      iconUrl: json['icon_url'] as String?,
    );
  }
}
