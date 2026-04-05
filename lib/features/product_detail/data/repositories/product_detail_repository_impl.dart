import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../home/data/models/product_model.dart';
import '../../domain/repositories/product_detail_repository.dart';
import '../datasources/product_detail_mock_datasource.dart';
import '../models/product_detail_model.dart';
import '../models/review_model.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailMockDatasource _mockDatasource;

  ProductDetailRepositoryImpl(this._mockDatasource);

  @override
  Future<Either<ApiException, ProductDetailModel>> getProductDetail(
    String id,
  ) async {
    try {
      final product = await _mockDatasource.getProductDetail(id);
      return Right(product);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ReviewModel>>> getReviews(
    String productId, {
    int page = 1,
  }) async {
    try {
      final reviews =
          await _mockDatasource.getReviews(productId, page: page);
      return Right(reviews);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ProductModel>>> getRelatedProducts(
    String productId,
  ) async {
    try {
      final products = await _mockDatasource.getRelatedProducts(productId);
      return Right(products);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> submitReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    // Mock: simulate successful submission
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right(null);
  }
}
