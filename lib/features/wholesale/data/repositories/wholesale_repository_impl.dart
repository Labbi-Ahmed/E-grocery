import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../domain/repositories/wholesale_repository.dart';
import '../datasources/wholesale_mock_datasource.dart';
import '../models/wholesale_product_model.dart';
import '../models/wholesale_cart_item_model.dart';

class WholesaleRepositoryImpl implements WholesaleRepository {
  final WholesaleMockDatasource _mockDatasource;

  WholesaleRepositoryImpl(this._mockDatasource);

  @override
  Future<Either<ApiException, List<WholesaleProductModel>>> getProducts() async {
    try {
      final products = await _mockDatasource.getProducts();
      return Right(products);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, WholesaleProductModel>> getProductDetail(String id) async {
    try {
      final product = await _mockDatasource.getProductDetail(id);
      return Right(product);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<WholesaleCartItemModel>>> getCartItems() async {
    try {
      final items = await _mockDatasource.getCartItems();
      return Right(items);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> updateQuantity(String id, int quantity) async {
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
}
