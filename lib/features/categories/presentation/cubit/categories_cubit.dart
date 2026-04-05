import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/categories_repository.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepository _repository;

  CategoriesCubit(this._repository) : super(const CategoriesState());

  Future<void> loadCategories() async {
    emit(state.copyWith(status: CategoriesStatus.loading));

    final result = await _repository.getCategories();

    result.fold(
      (error) => emit(state.copyWith(
        status: CategoriesStatus.error,
        errorMessage: error.message,
      )),
      (categories) => emit(state.copyWith(
        status: CategoriesStatus.loaded,
        categories: categories,
      )),
    );
  }
}
