import '../../../home/data/models/product_model.dart';

class WishlistMockDatasource {
  final List<ProductModel> _items = [
    const ProductModel(
      id: 'w1',
      name: 'Beef Kima',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Beef+Kima',
      price: 59.00,
      originalPrice: 100.00,
      rating: 4.5,
      reviewCount: 120,
      discountPercent: 50,
      unit: '1kg',
    ),
    const ProductModel(
      id: 'w2',
      name: 'Meat Big',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Meat+Big',
      price: 59.00,
      originalPrice: 130.00,
      rating: 4.3,
      reviewCount: 89,
      discountPercent: 50,
      unit: '500g',
    ),
    const ProductModel(
      id: 'w3',
      name: 'Beef Leg',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Beef+Leg',
      price: 59.00,
      originalPrice: 100.00,
      rating: 4.6,
      reviewCount: 203,
      discountPercent: 50,
      unit: '1kg',
    ),
    const ProductModel(
      id: 'w4',
      name: 'Beef Salt',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Beef+Salt',
      price: 59.00,
      originalPrice: 130.00,
      rating: 4.4,
      reviewCount: 156,
      discountPercent: 50,
      unit: '500g',
    ),
    const ProductModel(
      id: 'w5',
      name: 'Beef Liver',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Beef+Liver',
      price: 59.00,
      originalPrice: 100.00,
      rating: 4.2,
      reviewCount: 98,
      discountPercent: 50,
      unit: '500g',
    ),
    const ProductModel(
      id: 'w6',
      name: 'Beef Steak',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Beef+Steak',
      price: 59.00,
      originalPrice: 130.00,
      rating: 4.8,
      reviewCount: 312,
      discountPercent: 50,
      unit: '500g',
    ),
  ];

  Future<List<ProductModel>> getWishlist({String? sort, String? category}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var items = List<ProductModel>.from(_items);

    if (sort != null) {
      switch (sort) {
        case 'latest':
          break; // default order
        case 'reviews':
          items.sort((a, b) => (b.reviewCount ?? 0).compareTo(a.reviewCount ?? 0));
        case 'price_high':
          items.sort((a, b) => b.price.compareTo(a.price));
        case 'price_low':
          items.sort((a, b) => a.price.compareTo(b.price));
        case 'purchases':
          items.sort((a, b) => (b.reviewCount ?? 0).compareTo(a.reviewCount ?? 0));
      }
    }

    return items;
  }

  Future<void> removeItem(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _items.removeWhere((item) => item.id == productId);
  }
}
