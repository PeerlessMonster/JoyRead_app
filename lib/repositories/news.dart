import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../exceptions/storage_exception.dart';
import '../models/latest_news.dart';
import '../networks/news.dart';

Future<List<LatestNews>> loadLatestNews(int pageSize) async {
  const key = 'cache_latestNews';
  final box = GetStorage();

  var responseBody = await fetchLatestNews(pageSize);
  if (responseBody != null) {
    box.write(key, responseBody);
  } else {
    responseBody = box.read(key);
    if (responseBody == null) {
      throw NoCacheException();
    }
  }

  final parsed = jsonDecode(responseBody) as List;
  final jsonList = parsed.cast<Map<String, dynamic>>();
  return jsonList.map((json) => LatestNews.fromJson(json)).toList();
}
