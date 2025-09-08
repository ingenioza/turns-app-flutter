import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../error/failures.dart';

@singleton
class NetworkService {
  final Dio _dio;

  NetworkService(this._dio) {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );

    // Add error handling interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          debugPrint('Network Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return ServerFailure(
          message: _getErrorMessage(error),
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const NetworkFailure(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badCertificate:
        return const NetworkFailure(
          message: 'Certificate error. Please try again.',
        );
      case DioExceptionType.unknown:
        return NetworkFailure(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }

  String _getErrorMessage(DioException error) {
    try {
      final response = error.response;
      if (response?.data is Map<String, dynamic>) {
        final data = response!.data as Map<String, dynamic>;

        // Try to extract error message from common API response formats
        if (data.containsKey('message')) {
          return data['message'] as String;
        } else if (data.containsKey('error')) {
          final errorData = data['error'];
          if (errorData is String) {
            return errorData;
          } else if (errorData is Map<String, dynamic> &&
              errorData.containsKey('message')) {
            return errorData['message'] as String;
          }
        } else if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map<String, dynamic>) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first as String;
            }
          }
        }
      }

      // Fallback to status code message
      return 'Server error: ${response?.statusCode ?? 'Unknown'}';
    } catch (e) {
      return 'An error occurred while processing the response';
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
