import 'dart:io';

import 'package:http/http.dart' as http;

import '../../data/constant/media_type.dart';
import '../../fetch_config.dart';
import '../../utils/error_handling.dart';
import '../exceptions/http_exception.dart';

const _pathname = 'news';

Future<Result<String>> getLatestNews(http.Client client,
    {required int pageSize, int pageOrder = 0}) async {
  assert(pageOrder >= 0, 'Order of page should count from 0');
  assert(pageSize > 0, 'Size of page should be positive integer');

  final url = Uri.http(serverDomainName, '$_pathname/latest',
      {'pageOrder': '$pageOrder', 'pageSize': '$pageSize'});

  final header = {
    HttpHeaders.acceptHeader: MediaType.applicationJsonUtf8,
  };

  late final http.Response response;
  try {
    response = await client.get(url, headers: header);
  } on http.ClientException catch (e) {
    return Result.error(e);
  }

  return switch (response.statusCode) {
    200 => Result.ok(response.body),
    _ => Result.error(HttpException(url, response.statusCode)),
  };
}

Future<Result<String>> getTodayPopularNews(http.Client client,
    {required int pageSize, int pageOrder = 0}) async {
  assert(pageOrder >= 0, 'Order of page should count from 0');
  assert(pageSize > 0, 'Size of page should be positive integer');

  final url = Uri.http(serverDomainName, '$_pathname/popular/day',
      {'pageOrder': '$pageOrder', 'pageSize': '$pageSize'});

  final header = {
    HttpHeaders.acceptHeader: MediaType.applicationJsonUtf8,
  };

  late final http.Response response;
  try {
    response = await client.get(url, headers: header);
  } on http.ClientException catch (e) {
    return Result.error(e);
  }

  return switch (response.statusCode) {
    200 => Result.ok(response.body),
    _ => Result.error(HttpException(url, response.statusCode)),
  };
}

Future<Result<String>> getThisWeekPopularNews(http.Client client,
    {required int pageSize, int pageOrder = 0}) async {
  assert(pageOrder >= 0, 'Order of page should count from 0');
  assert(pageSize > 0, 'Size of page should be positive integer');

  final url = Uri.http(serverDomainName, '$_pathname/popular/week',
      {'pageOrder': '$pageOrder', 'pageSize': '$pageSize'});

  final header = {
    HttpHeaders.acceptHeader: MediaType.applicationJsonUtf8,
  };

  late final http.Response response;
  try {
    response = await client.get(url, headers: header);
  } on http.ClientException catch (e) {
    return Result.error(e);
  }

  return switch (response.statusCode) {
    200 => Result.ok(response.body),
    _ => Result.error(HttpException(url, response.statusCode)),
  };
}

Future<Result<String>> getNews(http.Client client, {required String id}) async {
  assert(id.isNotEmpty, 'ID is required');

  final url = Uri.http(serverDomainName, '$_pathname/$id');

  final header = {
    HttpHeaders.acceptHeader: MediaType.applicationJsonUtf8,
  };

  late final http.Response response;
  try {
    response = await client.get(url, headers: header);
  } on http.ClientException catch (e) {
    return Result.error(e);
  }

  return switch (response.statusCode) {
    200 => Result.ok(response.body),
    400 => Result.error(HttpException.badRequest(url)),
    404 => Result.error(HttpException.notFound(url)),
    _ => Result.error(HttpException(url, response.statusCode)),
  };
}
