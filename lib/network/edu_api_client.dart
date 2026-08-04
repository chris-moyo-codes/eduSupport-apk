import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../core/errors/app_exception.dart';

class EduApiClient {
  EduApiClient({Dio? dio}) : _dio = dio ?? Dio(_buildOptions());

  final Dio _dio;

  static BaseOptions _buildOptions() {
    return BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  Future<Response<T>> get<T>(String path) async {
    try {
      return await _dio.get<T>(path);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  AppException _mapError(DioException error) {
    if (error.response?.statusCode == 401) {
      return const UnauthorizedException(
        'Your EduSupport session is no longer valid.',
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkException('Unable to reach the EduSupport service.');
    }

    return NetworkException(error.message ?? 'Unexpected network failure.');
  }
}
