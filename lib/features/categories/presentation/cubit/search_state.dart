import '../../../home/data/models/product_model.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState {
  final SearchStatus status;
  final List<ProductModel> results;
  final List<String> suggestions;
  final List<String> recentSearches;
  final String query;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedEnd;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.suggestions = const [],
    this.recentSearches = const [],
    this.query = '',
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedEnd = false,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<ProductModel>? results,
    List<String>? suggestions,
    List<String>? recentSearches,
    String? query,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedEnd,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      recentSearches: recentSearches ?? this.recentSearches,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}
