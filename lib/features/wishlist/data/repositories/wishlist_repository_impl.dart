import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../home/data/models/product_model.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_mock_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistMockDatasource _mockDatasource;

  WishlistRepositoryImpl(this._mockDatasource);

  @override
  Future<Either<ApiException, List<ProductModel>>> getWishlist({
    String? sort,
    String? category,
  }) async {
    try {
      final items = await _mockDatasource.getWishlist(sort: sort, category: category);
      return Right(items);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> removeItem(String productId) async {
    try {
      await _mockDatasource.removeItem(productId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
