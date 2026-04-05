import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(const HomeState());

  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final results = await Future.wait([
      _homeRepository.getBanners(),
      _homeRepository.getCategories(),
      _homeRepository.getFeaturedProducts(),
      _homeRepository.getBestSelling(),
      _homeRepository.getPopularProducts(),
    ]);

    String? error;

    results[0].fold(
      (e) => error = e.message,
      (data) => emit(state.copyWith(
        banners: List<BannerModel>.from(data),
      )),
    );
    results[1].fold(
      (e) => error = e.message,
      (data) => emit(state.copyWith(
        categories: List<CategoryModel>.from(data),
      )),
    );
    results[2].fold(
      (e) => error = e.message,
      (data) => emit(state.copyWith(
        featuredProducts: List<ProductModel>.from(data),
      )),
    );
    results[3].fold(
      (e) => error = e.message,
      (data) => emit(state.copyWith(
        bestSelling: List<ProductModel>.from(data),
      )),
    );
    results[4].fold(
      (e) => error = e.message,
      (data) => emit(state.copyWith(
        popularProducts: List<ProductModel>.from(data),
      )),
    );

    if (error != null) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: error));
    } else {
      emit(state.copyWith(status: HomeStatus.loaded));
    }
  }

  Future<void> refresh() async {
    await loadHome();
  }
}
