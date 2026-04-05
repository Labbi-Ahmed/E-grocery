import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../home/data/models/product_model.dart';
import '../../../product_detail/data/models/review_model.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_mock_datasource.dart';
import '../models/store_model.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreMockDatasource _mockDatasource;

  StoreRepositoryImpl(this._mockDatasource);

  @override
  Future<Either<ApiException, List<StoreModel>>> getStores({String? sort}) async {
    try {
      final stores = await _mockDatasource.getStores(sort: sort);
      return Right(stores);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, StoreModel>> getStoreDetail(String id) async {
    try {
      final store = await _mockDatasource.getStoreDetail(id);
      return Right(store);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ProductModel>>> getStoreProducts(String storeId) async {
    try {
      final products = await _mockDatasource.getStoreProducts(storeId);
      return Right(products);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ReviewModel>>> getStoreReviews(String storeId) async {
    try {
      final reviews = await _mockDatasource.getStoreReviews(storeId);
      return Right(reviews);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
