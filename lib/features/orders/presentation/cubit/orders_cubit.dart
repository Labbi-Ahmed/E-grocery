import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/orders_repository.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _repository;

  OrdersCubit(this._repository) : super(const OrdersState());

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading));

    final result = await _repository.getOrders(status: state.activeTab);

    result.fold(
      (error) => emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: error.message,
      )),
      (orders) => emit(state.copyWith(
        status: OrdersStatus.loaded,
        orders: orders,
      )),
    );
  }

  Future<void> changeTab(String tab) async {
    emit(state.copyWith(activeTab: tab));
    await loadOrders();
  }
}
