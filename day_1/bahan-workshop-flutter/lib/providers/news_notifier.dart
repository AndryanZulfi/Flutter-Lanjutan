import 'dart:async';
import 'package:bahan_workshop/models/news_response.dart';
import 'package:bahan_workshop/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsProvider = AsyncNotifierProvider<NewsNotifier, List<Articles>>(NewsNotifier.new);

class NewsNotifier extends AsyncNotifier<List<Articles>>{

  String country = "us";
  String apiKey = "6259472dcef04116b2387b9e17d224b9";

  @override
  FutureOr<List<Articles>> build() {
    return ref.read(apiServiceProvider).getArticles(country, apiKey);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    try {
      final result = await ref.read(apiServiceProvider).getArticles(country, apiKey);
      state = AsyncValue.data(result);
    } catch (e, trace) {
      state = AsyncValue.error(e, trace);
    }
  }

}