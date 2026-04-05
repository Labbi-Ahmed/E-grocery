import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';

class CategoriesMockDatasource {
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      CategoryModel(id: '1', name: 'Grocery'),
      CategoryModel(id: '2', name: 'Meats'),
      CategoryModel(id: '3', name: 'Fish'),
      CategoryModel(id: '4', name: 'Drinks'),
      CategoryModel(id: '5', name: 'Bakery'),
      CategoryModel(id: '6', name: 'Fruits'),
      CategoryModel(id: '7', name: 'Poultry'),
      CategoryModel(id: '8', name: 'Sweets'),
      CategoryModel(id: '9', name: 'Noodles'),
      CategoryModel(id: '10', name: 'Frozen'),
      CategoryModel(id: '11', name: 'Others'),
      CategoryModel(id: '12', name: 'African'),
    ];
  }

  Future<List<ProductModel>> getCategoryProducts({
    required String categoryId,
    int page = 1,
    String? sort,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Return mock products; in real implementation filtered by categoryId
    final allProducts = _mockProducts;
    final start = (page - 1) * 10;
    if (start >= allProducts.length) return [];

    var products = allProducts.sublist(
      start,
      (start + 10).clamp(0, allProducts.length),
    );

    if (sort != null) {
      switch (sort) {
        case 'price_low':
          products = List.from(products)
            ..sort((a, b) => a.price.compareTo(b.price));
        case 'price_high':
          products = List.from(products)
            ..sort((a, b) => b.price.compareTo(a.price));
        case 'rating':
          products = List.from(products)
            ..sort((a, b) =>
                (b.rating ?? 0).compareTo(a.rating ?? 0));
        case 'newest':
          products = List.from(products.reversed);
      }
    }

    return products;
  }

  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final filtered = _mockProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final start = (page - 1) * 10;
    if (start >= filtered.length) return [];
    return filtered.sublist(start, (start + 10).clamp(0, filtered.length));
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return [];
    return _mockProducts
        .map((p) => p.name)
        .where((name) => name.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();
  }

  static const _mockProducts = [
    ProductModel(
      id: '1',
      name: 'Sunflower Oil',
      imageUrl: 'https://via.placeholder.com/300x300/FFF9C4/212121?text=Sunflower+Oil',
      price: 59.00,
      originalPrice: 75.00,
      rating: 4.5,
      reviewCount: 120,
      discountPercent: 21,
      unit: '1L',
    ),
    ProductModel(
      id: '2',
      name: 'Chicken Sharma',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Chicken',
      price: 140.00,
      originalPrice: 160.00,
      rating: 4.8,
      reviewCount: 89,
      discountPercent: 12,
      unit: '1kg',
    ),
    ProductModel(
      id: '3',
      name: 'Fresh Tilapia',
      imageUrl: 'https://via.placeholder.com/300x300/B3E5FC/212121?text=Tilapia',
      price: 95.00,
      originalPrice: 120.00,
      rating: 4.3,
      reviewCount: 67,
      discountPercent: 20,
      unit: '1kg',
    ),
    ProductModel(
      id: '4',
      name: 'Jollof Rice Mix',
      imageUrl: 'https://via.placeholder.com/300x300/FFECB3/212121?text=Jollof+Rice',
      price: 25.00,
      rating: 4.7,
      reviewCount: 203,
      unit: '500g',
    ),
    ProductModel(
      id: '5',
      name: 'Palm Oil',
      imageUrl: 'https://via.placeholder.com/300x300/FFE0B2/212121?text=Palm+Oil',
      price: 45.00,
      originalPrice: 55.00,
      rating: 4.6,
      reviewCount: 156,
      discountPercent: 18,
      unit: '1L',
    ),
    ProductModel(
      id: '6',
      name: 'Cassava Flour',
      imageUrl: 'https://via.placeholder.com/300x300/FFF9C4/212121?text=Cassava+Flour',
      price: 18.00,
      originalPrice: 22.00,
      rating: 4.4,
      reviewCount: 312,
      discountPercent: 18,
      unit: '1kg',
    ),
    ProductModel(
      id: '7',
      name: 'Egusi Seeds',
      imageUrl: 'https://via.placeholder.com/300x300/C8E6C9/212121?text=Egusi+Seeds',
      price: 32.00,
      rating: 4.6,
      reviewCount: 245,
      unit: '500g',
    ),
    ProductModel(
      id: '8',
      name: 'Plantain Chips',
      imageUrl: 'https://via.placeholder.com/300x300/FFE0B2/212121?text=Plantain+Chips',
      price: 12.00,
      originalPrice: 15.00,
      rating: 4.2,
      reviewCount: 189,
      discountPercent: 20,
      unit: '200g',
    ),
    ProductModel(
      id: '9',
      name: 'Dried Stockfish',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Stockfish',
      price: 85.00,
      originalPrice: 100.00,
      rating: 4.7,
      reviewCount: 134,
      discountPercent: 15,
      unit: '500g',
    ),
    ProductModel(
      id: '10',
      name: 'Suya Spice Mix',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Suya+Spice',
      price: 15.00,
      rating: 4.8,
      reviewCount: 420,
      unit: '200g',
    ),
    ProductModel(
      id: '11',
      name: 'Shea Butter',
      imageUrl: 'https://via.placeholder.com/300x300/FFF9C4/212121?text=Shea+Butter',
      price: 28.00,
      originalPrice: 35.00,
      rating: 4.5,
      reviewCount: 276,
      discountPercent: 20,
      unit: '250g',
    ),
    ProductModel(
      id: '12',
      name: 'Yam Flour (Poundo)',
      imageUrl: 'https://via.placeholder.com/300x300/C8E6C9/212121?text=Yam+Flour',
      price: 22.00,
      rating: 4.3,
      reviewCount: 198,
      unit: '1kg',
    ),
    ProductModel(
      id: '13',
      name: 'Groundnut Paste',
      imageUrl: 'https://via.placeholder.com/300x300/FFE0B2/212121?text=Groundnut',
      price: 19.00,
      originalPrice: 24.00,
      rating: 4.4,
      reviewCount: 167,
      discountPercent: 20,
      unit: '500g',
    ),
    ProductModel(
      id: '14',
      name: 'Okra (Frozen)',
      imageUrl: 'https://via.placeholder.com/300x300/C8E6C9/212121?text=Okra',
      price: 8.00,
      rating: 4.1,
      reviewCount: 95,
      unit: '500g',
    ),
    ProductModel(
      id: '15',
      name: 'Fufu Flour',
      imageUrl: 'https://via.placeholder.com/300x300/FFF9C4/212121?text=Fufu+Flour',
      price: 16.00,
      originalPrice: 20.00,
      rating: 4.5,
      reviewCount: 230,
      discountPercent: 20,
      unit: '1kg',
    ),
  ];
}
