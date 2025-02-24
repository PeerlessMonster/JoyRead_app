import 'package:http/http.dart' as http;

import 'fetch_config.dart';
import '../exceptions/http_exception.dart';

const _pathname = "news";

Future<String?> fetchLatestNews(int pageSize, [int pageOrder = 0]) async {
  assert(pageOrder >= 0, 'Order of page should count from 0');
  assert(pageSize > 0, 'Size of page should be positive integer');

  final url = Uri.http(serverDomainName, '$_pathname/latest',
      {'pageOrder': '$pageOrder', 'pageSize': '$pageSize'});

  late final http.Response response;
  try {
    response = await http.get(url);
  } on http.ClientException {
    return null;
  }

  if (response.statusCode != 200) {
    throw HttpException(url, HttpMethod.get, response.statusCode);
  }
  return response.body;
}
