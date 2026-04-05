import '../../data/models/store_model.dart';

enum StoreListStatus { initial, loading, loaded, error }

class StoreListState {
  final StoreListStatus status;
  final List<StoreModel> stores;
  final String? activeSort;
  final String? errorMessage;

  const StoreListState({
    this.status = StoreListStatus.initial,
    this.stores = const [],
    this.activeSort,
    this.errorMessage,
  });

  StoreListState copyWith({
    StoreListStatus? status,
    List<StoreModel>? stores,
    String? activeSort,
    String? errorMessage,
  }) {
    return StoreListState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      activeSort: activeSort ?? this.activeSort,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
