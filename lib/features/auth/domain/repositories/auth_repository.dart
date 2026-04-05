import 'package:dartz/dartz.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../data/models/auth_response_model.dart';

abstract class AuthRepository {
  Future<Either<ApiException, AuthResponseModel>> login({
    required String email,
    required String password,
  });

  Future<Either<ApiException, AuthResponseModel>> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  });

  Future<Either<ApiException, String>> forgotPassword({
    required String email,
  });

  Future<Either<ApiException, String>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<ApiException, String>> resetPassword({
    required String email,
    required String otp,
    required String password,
  });

  Future<bool> isLoggedIn();

  Future<void> logout();
}
