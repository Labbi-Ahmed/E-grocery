import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../home/data/models/product_model.dart';

abstract class WishlistRepository {
  Future<Either<ApiException, List<ProductModel>>> getWishlist({
    String? sort,
    String? category,
  });
  Future<Either<ApiException, void>> removeItem(String productId);
  Future<Either<ApiException, void>> addItem(ProductModel product);
  bool isWishlisted(String productId);
}
