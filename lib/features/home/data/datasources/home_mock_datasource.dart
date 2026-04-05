import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeMockDatasource {
  Future<List<BannerModel>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const [
      BannerModel(
        id: '1',
        imageUrl: 'https://via.placeholder.com/400x200/4CAF50/FFFFFF?text=Fresh+African+Groceries',
        title: 'Fresh African Groceries',
        subtitle: 'Up to 30% off on first order',
      ),
      BannerModel(
        id: '2',
        imageUrl: 'https://via.placeholder.com/400x200/2E7D32/FFFFFF?text=Free+Delivery',
        title: 'Free Delivery',
        subtitle: 'On orders above \$50',
      ),
      BannerModel(
        id: '3',
        imageUrl: 'https://via.placeholder.com/400x200/FFC107/212121?text=Weekend+Special',
        title: 'Weekend Special',
        subtitle: 'Buy 2 Get 1 Free',
      ),
    ];
  }

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
      CategoryModel(id: '8', name: 'Others'),
      CategoryModel(id: '9', name: 'African'),
    ];
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return const [
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
        imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Chicken+Sharma',
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
        imageUrl: 'https://via.placeholder.com/300x300/B3E5FC/212121?text=Fresh+Tilapia',
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
    ];
  }

  Future<List<ProductModel>> getBestSelling() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return const [
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
        imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Dried+Stockfish',
        price: 85.00,
        originalPrice: 100.00,
        rating: 4.7,
        reviewCount: 134,
        discountPercent: 15,
        unit: '500g',
      ),
    ];
  }

  Future<List<ProductModel>> getPopularProducts() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return const [
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
        imageUrl: 'https://via.placeholder.com/300x300/FFE0B2/212121?text=Groundnut+Paste',
        price: 19.00,
        originalPrice: 24.00,
        rating: 4.4,
        reviewCount: 167,
        discountPercent: 20,
        unit: '500g',
      ),
    ];
  }
}
