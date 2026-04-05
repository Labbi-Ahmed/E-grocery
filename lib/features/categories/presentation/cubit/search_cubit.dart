import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/categories_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final CategoriesRepository _repository;
  static const _recentSearchesKey = 'recent_searches';
  static const _maxRecentSearches = 10;

  SearchCubit(this._repository) : super(const SearchState());

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final recent = prefs.getStringList(_recentSearchesKey) ?? [];
    emit(state.copyWith(recentSearches: recent));
  }

  Future<void> updateSuggestions(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(suggestions: [], query: ''));
      return;
    }

    emit(state.copyWith(query: query));

    final result = await _repository.getSearchSuggestions(query);
    result.fold(
      (error) {},
      (suggestions) => emit(state.copyWith(suggestions: suggestions)),
    );
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    emit(state.copyWith(
      status: SearchStatus.loading,
      query: query,
      suggestions: [],
      currentPage: 1,
      hasReachedEnd: false,
    ));

    await _saveRecentSearch(query);

    final result = await _repository.searchProducts(
      query: query,
      page: 1,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: error.message,
      )),
      (products) => emit(state.copyWith(
        status: SearchStatus.loaded,
        results: products,
        currentPage: 1,
        hasReachedEnd: products.length < 10,
      )),
    );
  }

  Future<void> loadMore() async {
    if (state.hasReachedEnd || state.status == SearchStatus.loading) return;

    final nextPage = state.currentPage + 1;
    final result = await _repository.searchProducts(
      query: state.query,
      page: nextPage,
    );

    result.fold(
      (error) {},
      (products) => emit(state.copyWith(
        results: [...state.results, ...products],
        currentPage: nextPage,
        hasReachedEnd: products.length < 10,
      )),
    );
  }

  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
    emit(state.copyWith(recentSearches: []));
  }

  Future<void> removeRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final recent = List<String>.from(state.recentSearches)..remove(query);
    await prefs.setStringList(_recentSearchesKey, recent);
    emit(state.copyWith(recentSearches: recent));
  }

  Future<void> _saveRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final recent = List<String>.from(state.recentSearches)
      ..remove(query)
      ..insert(0, query);
    if (recent.length > _maxRecentSearches) {
      recent.removeRange(_maxRecentSearches, recent.length);
    }
    await prefs.setStringList(_recentSearchesKey, recent);
    emit(state.copyWith(recentSearches: recent));
  }
}
