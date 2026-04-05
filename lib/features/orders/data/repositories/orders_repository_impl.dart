import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_mock_datasource.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersMockDatasource _mockDatasource;

  OrdersRepositoryImpl(this._mockDatasource);

  @override
  Future<Either<ApiException, List<OrderModel>>> getOrders({String? status}) async {
    try {
      final orders = await _mockDatasource.getOrders(status: status);
      return Right(orders);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, OrderModel>> getOrderDetail(String id) async {
    try {
      final order = await _mockDatasource.getOrderDetail(id);
      return Right(order);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
