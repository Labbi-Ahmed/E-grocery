import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_mock_datasource.dart';
import '../models/cart_item_model.dart';
import '../models/address_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartMockDatasource _mockDatasource;

  CartRepositoryImpl(this._mockDatasource);

  @override
  Future<Either<ApiException, List<CartItemModel>>> getCartItems() async {
    try {
      final items = await _mockDatasource.getCartItems();
      return Right(items);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> updateQuantity(
    String id,
    int quantity,
  ) async {
    try {
      await _mockDatasource.updateQuantity(id, quantity);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> removeItem(String id) async {
    try {
      await _mockDatasource.removeItem(id);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, double>> applyCoupon(String code) async {
    try {
      final discount = await _mockDatasource.applyCoupon(code);
      return Right(discount);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<AddressModel>>> getAddresses() async {
    try {
      final addresses = await _mockDatasource.getAddresses();
      return Right(addresses);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> addAddress(AddressModel address) async {
    try {
      await _mockDatasource.addAddress(address);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, String>> placeOrder() async {
    try {
      final orderId = await _mockDatasource.placeOrder();
      return Right(orderId);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
