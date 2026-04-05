import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection.');
      default:
        return ApiException(message: 'Something went wrong. Please try again.');
    }
  }

  static ApiException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    String message = 'Something went wrong.';
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'] as String;
    }

    switch (statusCode) {
      case 400:
        return ApiException(message: message, statusCode: 400);
      case 401:
        return ApiException(message: 'Unauthorized. Please login again.', statusCode: 401);
      case 403:
        return ApiException(message: 'Access denied.', statusCode: 403);
      case 404:
        return ApiException(message: 'Resource not found.', statusCode: 404);
      case 422:
        return ApiException(message: message, statusCode: 422);
      case 500:
        return ApiException(message: 'Server error. Please try again later.', statusCode: 500);
      default:
        return ApiException(message: message, statusCode: statusCode);
    }
  }

  @override
  String toString() => message;
}
