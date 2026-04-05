class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.africanfoodmarket.com/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String socialLogin = '/auth/social-login';
  static const String logoutEndpoint = '/auth/logout';

  // Home
  static const String banners = '/home/banners';
  static const String homeCategories = '/home/categories';
  static const String featuredProducts = '/home/featured-products';
  static const String bestSelling = '/home/best-selling';
  static const String popularProducts = '/home/popular-products';

  // Categories
  static const String categories = '/categories';
  static String categoryProducts(String id) => '/categories/$id/products';

  // Search
  static const String searchProducts = '/search';
  static const String searchSuggestions = '/search/suggestions';

  // Products
  static String productDetail(String id) => '/products/$id';
  static String productReviews(String id) => '/products/$id/reviews';
  static String relatedProducts(String id) => '/products/$id/related';

  // Cart
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';
  static const String cartUpdate = '/cart/update';
  static String cartRemove(String id) => '/cart/remove/$id';
  static const String applyCoupon = '/cart/apply-coupon';

  // Addresses
  static const String addresses = '/addresses';
  static String addressById(String id) => '/addresses/$id';

  // Orders
  static const String placeOrder = '/orders/place';
  static const String orders = '/orders';
  static String orderDetail(String id) => '/orders/$id';
  static String orderTracking(String id) => '/orders/$id/tracking';
  static String rateOrder(String id) => '/orders/$id/rate';

  // Payment
  static const String paymentMethods = '/payment-methods';

  // Stores
  static const String stores = '/stores';
  static String storeDetail(String id) => '/stores/$id';
  static String storeProducts(String id) => '/stores/$id/products';
  static String storeReviews(String id) => '/stores/$id/reviews';
  static String followStore(String id) => '/stores/$id/follow';

  // Wishlist
  static const String wishlist = '/wishlist';
  static const String wishlistAdd = '/wishlist/add';
  static String wishlistRemove(String productId) => '/wishlist/remove/$productId';

  // Profile
  static const String profile = '/profile';
  static const String profileAvatar = '/profile/avatar';
  static const String notificationSettings = '/notifications/settings';

  // Wholesale
  static const String wholesaleProducts = '/wholesale/products';
  static String wholesaleProductDetail(String id) => '/wholesale/products/$id';
  static const String wholesaleCart = '/wholesale/cart';
  static const String wholesaleCartAdd = '/wholesale/cart/add';
  static String wholesalePricing(String id) => '/wholesale/pricing/$id';
}
