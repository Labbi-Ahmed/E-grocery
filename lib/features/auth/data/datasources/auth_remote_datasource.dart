import 'package:dio/dio.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/auth_response_model.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'full_name': fullName,
          'email': email,
          'password': password,
        },
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<String> forgotPassword({required String email}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      final data = response.data as Map<String, dynamic>;
      return data['message'] as String? ?? 'OTP sent successfully';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email, 'otp': otp},
      );
      final data = response.data as Map<String, dynamic>;
      return data['message'] as String? ?? 'OTP verified';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<String> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'otp': otp,
          'password': password,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return data['message'] as String? ?? 'Password reset successfully';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
