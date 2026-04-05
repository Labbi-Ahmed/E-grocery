import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';

abstract class CategoriesRepository {
  Future<Either<ApiException, List<CategoryModel>>> getCategories();

  Future<Either<ApiException, List<ProductModel>>> getCategoryProducts({
    required String categoryId,
    int page = 1,
    String? sort,
  });

  Future<Either<ApiException, List<ProductModel>>> searchProducts({
    required String query,
    int page = 1,
  });

  Future<Either<ApiException, List<String>>> getSearchSuggestions(String query);
}
