import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../../../../core/api/api_exceptions.dart';

/// Mock auth datasource for frontend-first development.
///
/// Dummy credentials:
///   Email: test@test.com
///   Password: 12345678
///
/// Any email + password (8+ chars) works for registration.
class AuthMockDatasource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == 'test@test.com' && password == '12345678') {
      return const AuthResponseModel(
        accessToken: 'mock_access_token_123',
        refreshToken: 'mock_refresh_token_456',
        user: UserModel(
          id: 'user1',
          fullName: 'John Doe',
          email: 'test@test.com',
          phone: '(415) 555-0128',
        ),
      );
    }

    throw ApiException(message: 'Invalid email or password', statusCode: 401);
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return AuthResponseModel(
      accessToken: 'mock_access_token_new',
      refreshToken: 'mock_refresh_token_new',
      user: UserModel(
        id: 'user_new',
        fullName: fullName,
        email: email,
        phone: phoneNumber,
      ),
    );
  }

  Future<String> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'OTP sent to $email';
  }

  Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (otp == '1234') return 'OTP verified';
    throw ApiException(message: 'Invalid OTP code', statusCode: 400);
  }

  Future<String> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Password reset successfully';
  }
}
