import 'package:bahan_workshop/models/news_response.dart';
import 'package:bahan_workshop/services/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_manager.dart';

final apiServiceProvider = Provider((ref) {
  return ApiService(ref.read(dioManagerProvider));
});

class ApiService {

  final DioManager client;
  ApiService(this.client);

  Future<List<Articles>> getArticles(String country, String apiKey) async {
    try {
      final response = await client.dio.get(
        "/top-headlines",
        queryParameters: {
          "country": country,
          "apiKey": apiKey,
        },
      );
      final newsResponse = NewsResponse.fromJson(response.data);
      return newsResponse.articles ?? [];
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException("Kesalahan tidak diketahui: $e");
    }
  }
}
