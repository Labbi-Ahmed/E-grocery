import 'package:dio/dio.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';

class CategoriesRemoteDatasource {
  final Dio _dio;

  CategoriesRemoteDatasource(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<ProductModel>> getCategoryProducts({
    required String categoryId,
    int page = 1,
    String? sort,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.categoryProducts(categoryId),
        queryParameters: {
          'page': page,
          if (sort != null) 'sort': sort,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.searchProducts,
        queryParameters: {'q': query, 'page': page},
      );
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.searchSuggestions,
        queryParameters: {'q': query},
      );
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>? ?? [];
      return list.map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
