import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_mock_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthMockDatasource _mockDatasource;
  final AuthLocalDatasource _localDatasource;

  AuthRepositoryImpl(this._mockDatasource, this._localDatasource);

  @override
  Future<Either<ApiException, AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _mockDatasource.login(
        email: email,
        password: password,
      );
      await _localDatasource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await _localDatasource.saveUser(response.user);
      return Right(response);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, AuthResponseModel>> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final response = await _mockDatasource.register(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      await _localDatasource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await _localDatasource.saveUser(response.user);
      return Right(response);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, String>> forgotPassword({
    required String email,
  }) async {
    try {
      final message = await _mockDatasource.forgotPassword(email: email);
      return Right(message);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final message = await _mockDatasource.verifyOtp(
        email: email,
        otp: otp,
      );
      return Right(message);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, String>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final message = await _mockDatasource.resetPassword(
        email: email,
        otp: otp,
        password: password,
      );
      return Right(message);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _localDatasource.hasToken();
  }

  @override
  Future<void> logout() async {
    await _localDatasource.clearAll();
  }
}
