import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_mock_datasource.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeMockDatasource _mockDatasource;

  HomeRepositoryImpl(this._mockDatasource);

  @override
  Future<Either<ApiException, List<BannerModel>>> getBanners() async {
    try {
      final banners = await _mockDatasource.getBanners();
      return Right(banners);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await _mockDatasource.getCategories();
      return Right(categories);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ProductModel>>> getFeaturedProducts() async {
    try {
      final products = await _mockDatasource.getFeaturedProducts();
      return Right(products);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ProductModel>>> getBestSelling() async {
    try {
      final products = await _mockDatasource.getBestSelling();
      return Right(products);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ProductModel>>> getPopularProducts() async {
    try {
      final products = await _mockDatasource.getPopularProducts();
      return Right(products);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
