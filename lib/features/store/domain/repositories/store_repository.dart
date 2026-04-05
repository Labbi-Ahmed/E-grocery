import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../home/data/models/product_model.dart';
import '../../../product_detail/data/models/review_model.dart';
import '../../data/models/store_model.dart';

abstract class StoreRepository {
  Future<Either<ApiException, List<StoreModel>>> getStores({String? sort});
  Future<Either<ApiException, StoreModel>> getStoreDetail(String id);
  Future<Either<ApiException, List<ProductModel>>> getStoreProducts(String storeId);
  Future<Either<ApiException, List<ReviewModel>>> getStoreReviews(String storeId);
}
