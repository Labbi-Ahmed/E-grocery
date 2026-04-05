import '../models/wholesale_product_model.dart';
import '../models/wholesale_cart_item_model.dart';

class WholesaleMockDatasource {
  final List<WholesaleCartItemModel> _cartItems = [
    const WholesaleCartItemModel(
      id: 'wc1',
      productId: 'wp1',
      name: 'Chicken Sharma',
      imageUrl: 'https://via.placeholder.com/200x200/FFCCBC/212121?text=Chicken',
      pricePerUnit: 120.00,
      quantity: 20,
      minOrderQuantity: 10,
      unit: '1kg',
      storeName: 'ABC Farmer',
    ),
    const WholesaleCartItemModel(
      id: 'wc2',
      productId: 'wp3',
      name: 'Cassava Flour',
      imageUrl: 'https://via.placeholder.com/200x200/FFF9C4/212121?text=Cassava',
      pricePerUnit: 14.00,
      quantity: 50,
      minOrderQuantity: 25,
      unit: '1kg',
      storeName: 'African Spice House',
    ),
  ];

  Future<List<WholesaleProductModel>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _products;
  }

  Future<WholesaleProductModel> getProductDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products.firstWhere((p) => p.id == id, orElse: () => _products.first);
  }

  Future<List<WholesaleCartItemModel>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_cartItems);
  }

  Future<void> updateQuantity(String id, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
    }
  }

  Future<void> removeItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.removeWhere((item) => item.id == id);
  }

  static const _products = [
    WholesaleProductModel(
      id: 'wp1',
      name: 'Beef Mix Eye Ball',
      imageUrl: 'https://via.placeholder.com/600x400/FFCCBC/212121?text=Beef+Mix',
      images: [
        'https://via.placeholder.com/600x400/FFCCBC/212121?text=Beef+1',
        'https://via.placeholder.com/600x400/FFCCBC/212121?text=Beef+2',
      ],
      retailPrice: 85.00,
      wholesalePrice: 65.00,
      minOrderQuantity: 10,
      rating: 4.7,
      reviewCount: 89,
      unit: '1kg',
      description:
          'Premium quality beef mix sourced from local farms. Perfect for restaurants, '
          'catering services, and bulk buyers. Each pack is vacuum-sealed for freshness '
          'and meets the highest food safety standards.',
      shippingInfo:
          'Wholesale delivery: 1-2 business days\n'
          'Free shipping on orders above \$500\n'
          'Cold chain delivery guaranteed\n'
          'Bulk orders may require 48hr advance notice',
      additionalInfo: {
        'Category': 'Meats',
        'Condition': 'Fresh',
        'Fridge Life': '3-5 days',
        'Freezer Life': '6 months',
        'Certifications': 'HACCP, Halal',
      },
      pricingTiers: [
        PricingTier(minQuantity: 10, maxQuantity: 24, pricePerUnit: 65.00),
        PricingTier(minQuantity: 25, maxQuantity: 49, pricePerUnit: 58.00),
        PricingTier(minQuantity: 50, maxQuantity: 99, pricePerUnit: 52.00),
        PricingTier(minQuantity: 100, pricePerUnit: 48.00),
      ],
      storeName: 'ABC Farmer',
      storeId: 'store1',
    ),
    WholesaleProductModel(
      id: 'wp2',
      name: 'Chicken Sharma Bulk',
      imageUrl: 'https://via.placeholder.com/600x400/FFCCBC/212121?text=Chicken+Bulk',
      retailPrice: 140.00,
      wholesalePrice: 110.00,
      minOrderQuantity: 10,
      rating: 4.8,
      reviewCount: 156,
      unit: '1kg',
      pricingTiers: [
        PricingTier(minQuantity: 10, maxQuantity: 24, pricePerUnit: 110.00),
        PricingTier(minQuantity: 25, maxQuantity: 49, pricePerUnit: 98.00),
        PricingTier(minQuantity: 50, pricePerUnit: 88.00),
      ],
    ),
    WholesaleProductModel(
      id: 'wp3',
      name: 'Cassava Flour Bulk',
      imageUrl: 'https://via.placeholder.com/600x400/FFF9C4/212121?text=Cassava+Bulk',
      retailPrice: 18.00,
      wholesalePrice: 14.00,
      minOrderQuantity: 25,
      rating: 4.4,
      reviewCount: 312,
      unit: '1kg',
      pricingTiers: [
        PricingTier(minQuantity: 25, maxQuantity: 49, pricePerUnit: 14.00),
        PricingTier(minQuantity: 50, maxQuantity: 99, pricePerUnit: 12.00),
        PricingTier(minQuantity: 100, pricePerUnit: 10.00),
      ],
    ),
    WholesaleProductModel(
      id: 'wp4',
      name: 'Palm Oil Bulk',
      imageUrl: 'https://via.placeholder.com/600x400/FFE0B2/212121?text=Palm+Oil+Bulk',
      retailPrice: 45.00,
      wholesalePrice: 35.00,
      minOrderQuantity: 20,
      rating: 4.6,
      reviewCount: 203,
      unit: '1L',
      pricingTiers: [
        PricingTier(minQuantity: 20, maxQuantity: 49, pricePerUnit: 35.00),
        PricingTier(minQuantity: 50, pricePerUnit: 30.00),
      ],
    ),
  ];
}
