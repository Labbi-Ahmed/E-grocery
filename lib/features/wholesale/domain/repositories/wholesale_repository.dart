import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../data/models/wholesale_product_model.dart';
import '../../data/models/wholesale_cart_item_model.dart';

abstract class WholesaleRepository {
  Future<Either<ApiException, List<WholesaleProductModel>>> getProducts();
  Future<Either<ApiException, WholesaleProductModel>> getProductDetail(String id);
  Future<Either<ApiException, List<WholesaleCartItemModel>>> getCartItems();
  Future<Either<ApiException, void>> updateQuantity(String id, int quantity);
  Future<Either<ApiException, void>> removeItem(String id);
}
