import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_config.dart';

// ==================== API Response State ====================
sealed class ApiState<T> {
  const ApiState();
}

class ApiInitial<T> extends ApiState<T> {
  const ApiInitial();
}

class ApiLoading<T> extends ApiState<T> {
  final double? progress;
  const ApiLoading({this.progress});
}

class ApiSuccess<T> extends ApiState<T> {
  final T data;
  final int? statusCode;
  const ApiSuccess(this.data, {this.statusCode});
}

class ApiError<T> extends ApiState<T> {
  final String message;
  final int? statusCode;
  final dynamic error;
  final ApiErrorType type;

  const ApiError({
    required this.message,
    this.statusCode,
    this.error,
    required this.type,
  });
}

enum ApiErrorType {
  noInternet,
  timeout,
  serverError,
  unauthorized,
  notFound,
  badRequest,
  unknown,
}

// ==================== API Client Configuration ====================
class ApiClientConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, dynamic>? headers;
  final bool enableLogging;

  const ApiClientConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.headers,
    this.enableLogging = true,
  });
}

// ==================== Dio Instance Provider ====================
final apiClientConfigProvider = Provider<ApiClientConfig>((ref) {
  return const ApiClientConfig(
    baseUrl: AppConfig.apiBaseUrl,
    enableLogging: true,
  );
});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(apiClientConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: config.headers ?? {'Content-Type': 'application/json'},
    ),
  );

  // Add interceptors
  if (config.enableLogging) {
    dio.interceptors.add(LoggingInterceptor());
  }
  dio.interceptors.add(ErrorInterceptor());

  return dio;
});

// ==================== API Client Service ====================
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // ==================== GET Request ====================
  Future<ApiState<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      await _checkInternetConnection();

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // ==================== POST Request ====================
  Future<ApiState<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      await _checkInternetConnection();

      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // ==================== PUT Request ====================
  Future<ApiState<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      await _checkInternetConnection();

      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // ==================== PATCH Request ====================
  Future<ApiState<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      await _checkInternetConnection();

      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // ==================== DELETE Request ====================
  Future<ApiState<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      await _checkInternetConnection();

      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // ==================== POST Multipart (with Progress) ====================
  Future<ApiState<T>> postMultipart<T>(
    String endpoint, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    void Function(double)? onProgress,
    T Function(dynamic)? parser,
  }) async {
    try {
      await _checkInternetConnection();

      final response = await _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: Options(headers: headers, contentType: 'multipart/form-data'),
        onSendProgress: (sent, total) {
          if (onProgress != null && total != -1) {
            final progress = (sent / total * 100).roundToDouble();
            onProgress(progress);
          }
        },
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // ==================== PUT Multipart (with Progress) ====================
  Future<ApiState<T>> putMultipart<T>(
    String endpoint, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    void Function(double)? onProgress,
    T Function(dynamic)? parser,
  }) async {
    try {
      await _checkInternetConnection();

      final response = await _dio.put(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: Options(headers: headers, contentType: 'multipart/form-data'),
        onSendProgress: (sent, total) {
          if (onProgress != null && total != -1) {
            final progress = (sent / total * 100).roundToDouble();
            onProgress(progress);
          }
        },
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // ==================== Download File (with Progress) ====================
  Future<ApiState<String>> downloadFile(
    String endpoint,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    void Function(double)? onProgress,
  }) async {
    try {
      await _checkInternetConnection();

      await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: (received, total) {
          if (onProgress != null && total != -1) {
            final progress = (received / total * 100).roundToDouble();
            onProgress(progress);
          }
        },
      );

      return ApiSuccess<String>(savePath, statusCode: 200);
    } catch (e) {
      return _handleError<String>(e);
    }
  }

  // ==================== Helper Methods ====================
  Future<void> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw const SocketException('No Internet Connection');
      }
    } on SocketException {
      throw const SocketException('No Internet Connection');
    }
  }

  ApiState<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? parser,
  ) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final data = parser != null ? parser(response.data) : response.data as T;
      return ApiSuccess<T>(data, statusCode: response.statusCode);
    } else {
      return ApiError<T>(
        message: 'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
        type: _getErrorType(response.statusCode),
      );
    }
  }

  ApiState<T> _handleError<T>(dynamic error) {
    if (error is DioException) {
      return _handleDioError<T>(error);
    } else if (error is SocketException) {
      return ApiError<T>(
        message: 'No internet connection',
        type: ApiErrorType.noInternet,
        error: error,
      );
    } else {
      return ApiError<T>(
        message: error.toString(),
        type: ApiErrorType.unknown,
        error: error,
      );
    }
  }

  ApiState<T> _handleDioError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError<T>(
          message: 'Connection timeout. Please try again.',
          type: ApiErrorType.timeout,
          error: error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return ApiError<T>(
          message: _getErrorMessage(statusCode, error.response?.data),
          statusCode: statusCode,
          type: _getErrorType(statusCode),
          error: error,
        );

      case DioExceptionType.cancel:
        return ApiError<T>(
          message: 'Request was cancelled',
          type: ApiErrorType.unknown,
          error: error,
        );

      case DioExceptionType.connectionError:
        return ApiError<T>(
          message: 'No internet connection',
          type: ApiErrorType.noInternet,
          error: error,
        );

      default:
        return ApiError<T>(
          message: 'Something went wrong. Please try again.',
          type: ApiErrorType.unknown,
          error: error,
        );
    }
  }

  ApiErrorType _getErrorType(int? statusCode) {
    if (statusCode == null) return ApiErrorType.unknown;

    switch (statusCode) {
      case 400:
        return ApiErrorType.badRequest;
      case 401:
      case 403:
        return ApiErrorType.unauthorized;
      case 404:
        return ApiErrorType.notFound;
      case >= 500:
        return ApiErrorType.serverError;
      default:
        return ApiErrorType.unknown;
    }
  }

  String _getErrorMessage(int? statusCode, dynamic responseData) {
    // Try to extract dynamic error message from response
    if (responseData != null) {
      try {
        String? extractedMessage;

        if (responseData is Map) {
          // Check for common error keys
          extractedMessage =
              responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              responseData['msg']?.toString() ??
              responseData['errors']?.toString() ??
              responseData['detail']?.toString();

          // Handle nested error objects
          if (extractedMessage == null && responseData['error'] is Map) {
            extractedMessage = responseData['error']['message']?.toString();
          }

          // Handle error arrays
          if (extractedMessage == null && responseData['errors'] is List) {
            final errors = responseData['errors'] as List;
            if (errors.isNotEmpty) {
              if (errors.first is String) {
                extractedMessage = errors.first.toString();
              } else if (errors.first is Map) {
                extractedMessage =
                    errors.first['message']?.toString() ??
                    errors.first['error']?.toString();
              }
            }
          }
        } else if (responseData is String) {
          extractedMessage = responseData;
        }

        // Return extracted message if found and not empty
        if (extractedMessage != null && extractedMessage.isNotEmpty) {
          return extractedMessage;
        }
      } catch (e) {
        dev.log('Error parsing response message: $e', name: 'API Client');
      }
    }

    // Fallback to default messages based on status code
    return _getDefaultErrorMessage(statusCode);
  }

  String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

// ==================== Logging Interceptor ====================
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dev.log(
      '🌐 REQUEST[${options.method}] => ${options.uri}',
      name: 'API Client',
    );
    dev.log('Headers: ${options.headers}', name: 'API Client');
    if (options.data != null) {
      dev.log('Body: ${options.data}', name: 'API Client');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log(
      '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}',
      name: 'API Client',
    );
    dev.log('Data: ${response.data}', name: 'API Client');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dev.log(
      '❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.uri}',
      name: 'API Client',
    );
    dev.log('Message: ${err.message}', name: 'API Client');
    if (err.response?.data != null) {
      dev.log('Error Data: ${err.response?.data}', name: 'API Client');
    }
    super.onError(err, handler);
  }
}

// ==================== Error Interceptor ====================
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // You can add global error handling here
    // For example, auto-refresh token on 401, show snackbar, etc.
    super.onError(err, handler);
  }
}

// ==================== Usage Example ====================
/*
// 1. Configure the base URL
final apiClientConfigProvider = Provider<ApiClientConfig>((ref) {
  return const ApiClientConfig(
    baseUrl: 'https://api.example.com',
    enableLogging: true,
  );
});

// 2. Create a repository
class UserRepository {
  final ApiClient _client;
  UserRepository(this._client);

  Future<ApiState<User>> getUser(String id) async {
    return _client.get<User>(
      '/users/$id',
      parser: (data) => User.fromJson(data),
    );
  }

  Future<ApiState<User>> createUser(Map<String, dynamic> userData) async {
    return _client.post<User>(
      '/users',
      data: userData,
      parser: (data) => User.fromJson(data),
    );
  }

  Future<ApiState<String>> uploadAvatar(File imageFile) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(imageFile.path),
      'userId': '123',
    });

    return _client.postMultipart<String>(
      '/users/avatar',
      formData: formData,
      onProgress: (progress) {
        print('Upload progress: $progress%');
      },
      parser: (data) => data['url'],
    );
  }
}

// 3. Create provider for repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return UserRepository(client);
});

// 4. Use in a StateNotifier or AsyncNotifier
class UserNotifier extends StateNotifier<ApiState<User>> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(const ApiInitial());

  Future<void> fetchUser(String id) async {
    state = const ApiLoading();
    state = await _repository.getUser(id);
  }

  Future<void> uploadAvatar(File imageFile) async {
    state = const ApiLoading();
    state = await _repository.uploadAvatar(imageFile);
  }
}

final userNotifierProvider = StateNotifierProvider<UserNotifier, ApiState<User>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserNotifier(repository);
});

// 5. Use in UI
class UserProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);

    return userState.when(
      initial: () => const SizedBox.shrink(),
      loading: (progress) => Center(
        child: progress != null
            ? CircularProgressIndicator(value: progress / 100)
            : const CircularProgressIndicator(),
      ),
      success: (user, _) => Text('Welcome ${user.name}'),
      error: (message, statusCode, error, type) {
        if (type == ApiErrorType.noInternet) {
          return const Text('No internet connection');
        }
        return Text('Error: $message');
      },
    );
  }
}

// Extension for easier state handling
extension ApiStateExtension<T> on ApiState<T> {
  R when<R>({
    required R Function() initial,
    required R Function(double? progress) loading,
    required R Function(T data, int? statusCode) success,
    required R Function(String message, int? statusCode, dynamic error, ApiErrorType type) error,
  }) {
    final state = this;
    if (state is ApiInitial<T>) {
      return initial();
    } else if (state is ApiLoading<T>) {
      return loading(state.progress);
    } else if (state is ApiSuccess<T>) {
      return success(state.data, state.statusCode);
    } else if (state is ApiError<T>) {
      return error(state.message, state.statusCode, state.error, state.type);
    }
    throw Exception('Unknown state');
  }
}
*/
