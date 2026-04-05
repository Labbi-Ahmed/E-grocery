import '../../../home/data/models/product_model.dart';
import '../../../product_detail/data/models/review_model.dart';
import '../models/store_model.dart';

class StoreMockDatasource {
  Future<List<StoreModel>> getStores({String? sort}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    var stores = List<StoreModel>.from(_stores);
    if (sort == 'popular') {
      stores.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    } else if (sort == 'newest') {
      stores = stores.reversed.toList();
    }
    return stores;
  }

  Future<StoreModel> getStoreDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _stores.firstWhere((s) => s.id == id, orElse: () => _stores.first);
  }

  Future<List<ProductModel>> getStoreProducts(String storeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _storeProducts;
  }

  Future<List<ReviewModel>> getStoreReviews(String storeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _storeReviews;
  }

  static const _stores = [
    StoreModel(
      id: 'store1',
      name: 'Ni-ana\'s Kitchen',
      imageUrl: 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=NK',
      bannerUrl: 'https://via.placeholder.com/800x300/2E7D32/FFFFFF?text=Nianas+Kitchen',
      rating: 4.9,
      reviewCount: 256,
      productCount: 48,
      description:
          'NIANAS is a family of talented people passionate about food. We believe in spreading love and happiness through food, and are inspired by Africa\'s culinary traditions. Our mission is to bring traditional African flavors to your doorstep. We make what\'s in season extraordinary, crafting products that celebrate the rich culinary heritage of Africa while meeting the highest quality standards.',
      address: 'Online Mission, San Francisco, CA 94103',
      phone: '(415) 555-0198',
      socialLinks: {
        'facebook': 'https://facebook.com',
        'instagram': 'https://instagram.com',
        'youtube': 'https://youtube.com',
        'twitter': 'https://twitter.com',
      },
    ),
    StoreModel(
      id: 'store2',
      name: 'Mama\'s Market',
      imageUrl: 'https://via.placeholder.com/100x100/FFC107/212121?text=MM',
      bannerUrl: 'https://via.placeholder.com/800x300/FFA000/FFFFFF?text=Mamas+Market',
      rating: 4.7,
      reviewCount: 189,
      productCount: 35,
      description: 'Your one-stop shop for authentic African meats and spices.',
      address: '123 Market St, San Francisco, CA 94102',
    ),
    StoreModel(
      id: 'store3',
      name: 'FruiShop',
      imageUrl: 'https://via.placeholder.com/100x100/8BC34A/FFFFFF?text=FS',
      bannerUrl: 'https://via.placeholder.com/800x300/689F38/FFFFFF?text=FruiShop',
      rating: 4.5,
      reviewCount: 142,
      productCount: 28,
      description: 'Fresh tropical fruits delivered daily from African farms.',
      address: '456 Fruit Ave, San Francisco, CA 94104',
    ),
    StoreModel(
      id: 'store4',
      name: 'African Spice House',
      imageUrl: 'https://via.placeholder.com/100x100/FF5722/FFFFFF?text=ASH',
      bannerUrl: 'https://via.placeholder.com/800x300/E64A19/FFFFFF?text=African+Spice+House',
      rating: 4.8,
      reviewCount: 312,
      productCount: 62,
      description: 'Premium spices and seasonings from across Africa.',
      address: '789 Spice Blvd, San Francisco, CA 94105',
    ),
  ];

  static const _storeProducts = [
    ProductModel(
      id: '1',
      name: 'Beef Floss',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Beef+Floss',
      price: 59.00,
      originalPrice: 75.00,
      rating: 4.5,
      reviewCount: 120,
      discountPercent: 21,
      unit: '250g',
    ),
    ProductModel(
      id: '2',
      name: 'Veal Rig',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Veal+Rig',
      price: 84.00,
      originalPrice: 95.00,
      rating: 4.3,
      reviewCount: 89,
      discountPercent: 12,
      unit: '500g',
    ),
    ProductModel(
      id: '3',
      name: 'Beef Floss',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Beef+Floss+2',
      price: 59.00,
      originalPrice: 69.00,
      rating: 4.6,
      reviewCount: 67,
      discountPercent: 15,
      unit: '250g',
    ),
    ProductModel(
      id: '4',
      name: 'Lamb Chops',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Lamb+Chops',
      price: 120.00,
      originalPrice: 140.00,
      rating: 4.8,
      reviewCount: 203,
      discountPercent: 14,
      unit: '1kg',
    ),
    ProductModel(
      id: '5',
      name: 'Beef Steak',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Beef+Steak',
      price: 95.00,
      rating: 4.7,
      reviewCount: 156,
      unit: '500g',
    ),
    ProductModel(
      id: '6',
      name: 'Suya Mix',
      imageUrl: 'https://via.placeholder.com/300x300/FFCCBC/212121?text=Suya+Mix',
      price: 25.00,
      originalPrice: 30.00,
      rating: 4.4,
      reviewCount: 98,
      discountPercent: 17,
      unit: '200g',
    ),
  ];

  static const _storeReviews = [
    ReviewModel(
      id: 'r1',
      userName: 'Sampreeth Khattar',
      rating: 5.0,
      comment: 'The store was really, really hot! I usually take out all friends and family here.',
      date: '2 days ago',
    ),
    ReviewModel(
      id: 'r2',
      userName: 'Oyin Billion',
      rating: 4.5,
      comment: 'Great cookware, its none in quality and cost effective.',
      date: '1 week ago',
    ),
    ReviewModel(
      id: 'r3',
      userName: 'Tynisha Obiol',
      rating: 5.0,
      comment: 'Great food. They are beautiful. The family. They understand about quality, any customer service is awesome and trustworthy.',
      date: '2 weeks ago',
    ),
  ];
}
