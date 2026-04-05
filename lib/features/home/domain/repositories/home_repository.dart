import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

abstract class HomeRepository {
  Future<Either<ApiException, List<BannerModel>>> getBanners();
  Future<Either<ApiException, List<CategoryModel>>> getCategories();
  Future<Either<ApiException, List<ProductModel>>> getFeaturedProducts();
  Future<Either<ApiException, List<ProductModel>>> getBestSelling();
  Future<Either<ApiException, List<ProductModel>>> getPopularProducts();
}
