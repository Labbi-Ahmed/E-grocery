import '../../data/models/banner_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState {
  final HomeStatus status;
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<ProductModel> featuredProducts;
  final List<ProductModel> bestSelling;
  final List<ProductModel> popularProducts;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.banners = const [],
    this.categories = const [],
    this.featuredProducts = const [],
    this.bestSelling = const [],
    this.popularProducts = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<BannerModel>? banners,
    List<CategoryModel>? categories,
    List<ProductModel>? featuredProducts,
    List<ProductModel>? bestSelling,
    List<ProductModel>? popularProducts,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      bestSelling: bestSelling ?? this.bestSelling,
      popularProducts: popularProducts ?? this.popularProducts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
