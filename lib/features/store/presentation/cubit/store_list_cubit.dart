import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/store_repository.dart';
import 'store_list_state.dart';

class StoreListCubit extends Cubit<StoreListState> {
  final StoreRepository _repository;

  StoreListCubit(this._repository) : super(const StoreListState());

  Future<void> loadStores() async {
    emit(state.copyWith(status: StoreListStatus.loading));

    final result = await _repository.getStores(sort: state.activeSort);

    result.fold(
      (error) => emit(state.copyWith(
        status: StoreListStatus.error,
        errorMessage: error.message,
      )),
      (stores) => emit(state.copyWith(
        status: StoreListStatus.loaded,
        stores: stores,
      )),
    );
  }

  Future<void> changeSort(String? sort) async {
    emit(state.copyWith(activeSort: sort));
    await loadStores();
  }
}
