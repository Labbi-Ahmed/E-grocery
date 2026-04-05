import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../home/data/models/product_model.dart';
import '../../data/models/product_detail_model.dart';
import '../../data/models/review_model.dart';

abstract class ProductDetailRepository {
  Future<Either<ApiException, ProductDetailModel>> getProductDetail(String id);
  Future<Either<ApiException, List<ReviewModel>>> getReviews(
    String productId, {
    int page = 1,
  });
  Future<Either<ApiException, List<ProductModel>>> getRelatedProducts(
    String productId,
  );
  Future<Either<ApiException, void>> submitReview({
    required String productId,
    required double rating,
    required String comment,
  });
}
