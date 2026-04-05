import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../data/models/order_model.dart';

abstract class OrdersRepository {
  Future<Either<ApiException, List<OrderModel>>> getOrders({String? status});
  Future<Either<ApiException, OrderModel>> getOrderDetail(String id);
}
