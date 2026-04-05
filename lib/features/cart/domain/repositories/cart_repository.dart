import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/address_model.dart';

abstract class CartRepository {
  Future<Either<ApiException, List<CartItemModel>>> getCartItems();
  Future<Either<ApiException, void>> updateQuantity(String id, int quantity);
  Future<Either<ApiException, void>> removeItem(String id);
  Future<Either<ApiException, double>> applyCoupon(String code);
  Future<Either<ApiException, List<AddressModel>>> getAddresses();
  Future<Either<ApiException, void>> addAddress(AddressModel address);
  Future<Either<ApiException, String>> placeOrder();
}
