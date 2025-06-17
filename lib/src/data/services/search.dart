import 'dart:io';

import 'package:http/http.dart' as http;

import '../../fetch_config.dart';
import '../../utils/error_handling.dart';
import '../constant/media_type.dart';
import '../exceptions/http_exception.dart';

const _header = {
  HttpHeaders.acceptHeader: MediaType.applicationJsonUtf8,
};

Future<Result<String>> getSearchResult(http.Client client,
    {required String query}) async {
  assert(query.isNotEmpty, 'Query is required');

  final url = Uri.http(serverDomainName, '/search', {'query': query});

  late final http.Response response;
  try {
    response = await client.get(url, headers: _header);
  } on http.ClientException catch (e) {
    return Result.error(e);
  }

  return switch (response.statusCode) {
    200 => Result.ok(response.body),
    _ => Result.error(HttpException(url, response.statusCode)),
  };
}
