import '../../../home/data/models/product_model.dart';
import '../models/product_detail_model.dart';
import '../models/review_model.dart';

class ProductDetailMockDatasource {
  Future<ProductDetailModel> getProductDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ProductDetailModel(
      id: id,
      name: 'Chicken Sharma',
      imageUrl:
          'https://via.placeholder.com/600x400/FFCCBC/212121?text=Chicken+Sharma',
      images: [
        'https://via.placeholder.com/600x400/FFCCBC/212121?text=Chicken+1',
        'https://via.placeholder.com/600x400/FFCCBC/212121?text=Chicken+2',
        'https://via.placeholder.com/600x400/FFCCBC/212121?text=Chicken+3',
      ],
      price: 140.00,
      originalPrice: 160.00,
      rating: 4.8,
      reviewCount: 89,
      discountPercent: 12,
      unit: '1kg',
      description:
          'Premium quality chicken sharma sourced from local African farms. '
          'Our chicken is raised free-range and fed with natural grains, '
          'ensuring the best flavor and nutrition. Perfect for grilling, '
          'roasting, or making traditional African stews. Each pack contains '
          'carefully selected cuts that are fresh and ready to cook. '
          'Our products undergo strict quality control to ensure freshness '
          'and food safety standards are met.',
      shippingInfo:
          'Standard delivery: 2-3 business days\n'
          'Express delivery: Same day (orders before 2 PM)\n'
          'Free shipping on orders above \$50\n'
          'Delivery charges: \$5.99 for orders below \$50',
      additionalInfo: const {
        'Category': 'Meats',
        'Condition': 'Fresh',
        'Fridge Life': '3-5 days',
        'Freezer Life': '6 months',
        'Origin': 'West Africa',
        'Weight': '1kg per pack',
      },
      storeId: 'store1',
      storeName: 'ABC Farmer',
      storeImage:
          'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=ABC',
      storeRating: 4.9,
      variants: const ['500g', '1kg', '2kg', '5kg'],
      selectedVariant: '1kg',
    );
  }

  Future<List<ReviewModel>> getReviews(String productId, {int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (page > 1) return [];
    return const [
      ReviewModel(
        id: '1',
        userName: 'Sarah M.',
        rating: 5.0,
        comment:
            'Excellent quality chicken! Very fresh and tasty. Will definitely order again.',
        date: '2 days ago',
      ),
      ReviewModel(
        id: '2',
        userName: 'John D.',
        rating: 4.5,
        comment:
            'Good quality overall. The delivery was fast and the packaging was great.',
        date: '1 week ago',
      ),
      ReviewModel(
        id: '3',
        userName: 'Amara K.',
        rating: 5.0,
        comment: 'Best chicken sharma I\'ve found online. Reminds me of home!',
        date: '2 weeks ago',
      ),
      ReviewModel(
        id: '4',
        userName: 'David O.',
        rating: 4.0,
        comment:
            'Nice product but slightly smaller portions than expected. Taste is great though.',
        date: '3 weeks ago',
      ),
      ReviewModel(
        id: '5',
        userName: 'Fatima B.',
        rating: 4.5,
        comment: 'Very fresh and well packaged. Good value for money.',
        date: '1 month ago',
      ),
    ];
  }

  Future<List<ProductModel>> getRelatedProducts(String productId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      ProductModel(
        id: '2',
        name: 'Dried Stockfish',
        imageUrl:
            'https://via.placeholder.com/300x300/FFCCBC/212121?text=Stockfish',
        price: 85.00,
        originalPrice: 100.00,
        rating: 4.7,
        reviewCount: 134,
        discountPercent: 15,
        unit: '500g',
      ),
      ProductModel(
        id: '3',
        name: 'Fresh Tilapia',
        imageUrl:
            'https://via.placeholder.com/300x300/B3E5FC/212121?text=Tilapia',
        price: 95.00,
        originalPrice: 120.00,
        rating: 4.3,
        reviewCount: 67,
        discountPercent: 20,
        unit: '1kg',
      ),
      ProductModel(
        id: '4',
        name: 'Suya Spice Mix',
        imageUrl:
            'https://via.placeholder.com/300x300/FFCCBC/212121?text=Suya+Spice',
        price: 15.00,
        rating: 4.8,
        reviewCount: 420,
        unit: '200g',
      ),
      ProductModel(
        id: '5',
        name: 'Egusi Seeds',
        imageUrl:
            'https://via.placeholder.com/300x300/C8E6C9/212121?text=Egusi',
        price: 32.00,
        rating: 4.6,
        reviewCount: 245,
        unit: '500g',
      ),
    ];
  }
}
