import 'package:dartz/dartz.dart';
import 'api_exceptions.dart';

typedef ApiResult<T> = Future<Either<ApiException, T>>;
