import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_mock_datasource.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesMockDatasource _mockDatasource;

  CategoriesRepositoryImpl(this._mockDatasource);

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
  Future<Either<ApiException, List<ProductModel>>> getCategoryProducts({
    required String categoryId,
    int page = 1,
    String? sort,
  }) async {
    try {
      final products = await _mockDatasource.getCategoryProducts(
        categoryId: categoryId,
        page: page,
        sort: sort,
      );
      return Right(products);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ProductModel>>> searchProducts({
    required String query,
    int page = 1,
  }) async {
    try {
      final products = await _mockDatasource.searchProducts(
        query: query,
        page: page,
      );
      return Right(products);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<String>>> getSearchSuggestions(
    String query,
  ) async {
    try {
      final suggestions = await _mockDatasource.getSearchSuggestions(query);
      return Right(suggestions);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
