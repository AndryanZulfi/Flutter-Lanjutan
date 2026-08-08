import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recipes_app/models/MealsResponse.dart';

class RemoteService {

  static const baseUrl = "https://www.themealdb.com/api/json/v1/1/";
  
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    )
  );

  RemoteService(){
    if(kDebugMode){
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
        )
      );
    }
  }

  Future<List<Meals>?> fetchMealByCategory(String category) async {
    try{
      final response = await _dio.get(
        "filter.php",
        queryParameters: {"c": category}
        );
        return MealsResponse.fromJson(response.data).meals;
    }on DioException catch (dio){
      debugPrint("[DioException] fetchMealByCategory: ${dio.message} | response: ${dio.response?.data}");
      throw "gagal mengambil data berdasarkan kategori: ${dio.message}";
    }catch(e){
      throw "Kesalahan tak terduga";
    }
  }


  Future<Meals> fetchMealById(String id) async {
    try{
      final response = await _dio.get(
        "lookup.php",
        queryParameters: {"i": id}
        );
        return MealsResponse.fromJson(response.data).meals?.first ?? Meals();
    }on DioException catch (dio){
      debugPrint("[DioException] fetchMealById: ${dio.message} | response: ${dio.response?.data}");
      throw "gagal mengambil data berdasarkan id: ${dio.message}";
    }catch(e){
      throw "Kesalahan tak terduga";
    }
  }
}