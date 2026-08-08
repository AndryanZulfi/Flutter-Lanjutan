import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioManagerProvider = Provider((ref) => DioManager());

class DioManager {

  final Dio dio;

  DioManager() : dio = Dio(
    BaseOptions(
      baseUrl: "https://newsapi.org/v2",
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 1),
      receiveTimeout: const Duration(seconds: 1),
      sendTimeout: const Duration(seconds: 1),
    ),
  ) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler,) async {
    handler.next(options);
  }

  Future<void> _onResponse(Response res, ResponseInterceptorHandler handler,) async {
    if (res.statusCode != 200) {
      return handler.reject(
        DioException(
          requestOptions: res.requestOptions,
          message: res.data.toString(),
        ),
      );
    }
    return handler.next(res);
  }

  Future<void> _onError(DioException e, ErrorInterceptorHandler handler,) async {
    return handler.reject(e);
  }

}
