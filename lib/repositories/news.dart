import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../exceptions/storage_exception.dart';
import '../models/latest_news.dart';
import '../networks/news.dart';

Future<List<LatestNews>> loadLatestNewsWithCache(http.Client client,
    {required int pageSize, int pageOrder = 0}) async {
  const key = 'cache_latestNews';
  final box = GetStorage();

  String? responseBody;
  try {
    responseBody =
        await fetchLatestNews(client, pageSize: pageSize, pageOrder: pageOrder);
    box.write(key, responseBody);
  } on http.ClientException {
    responseBody = box.read(key);
    if (responseBody == null) {
      throw NoCacheException();
    }
  } on HttpException catch (e) {
    switch (e.statusCode) {
      default:
        rethrow;
    }
  }

  final parsed = jsonDecode(responseBody) as List;
  final jsonList = parsed.cast<Map<String, dynamic>>();
  return jsonList.map((json) => LatestNews.fromJson(json)).toList();
}

Future<List<LatestNews>> loadLatestNews(http.Client client,
    {required int pageSize, int pageOrder = 0}) async {
  final responseBody =
      await fetchLatestNews(client, pageSize: pageSize, pageOrder: pageOrder);
  final parsed = jsonDecode(responseBody) as List;
  final jsonList = parsed.cast<Map<String, dynamic>>();
  return jsonList.map((json) => LatestNews.fromJson(json)).toList();
}
