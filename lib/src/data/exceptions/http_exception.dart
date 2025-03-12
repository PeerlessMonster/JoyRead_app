class HttpException implements Exception {
  final Uri url;
  final HttpMethod method;
  final int statusCode;

  const HttpException(this.url, this.method, this.statusCode);
}

enum HttpMethod { get, post, put, patch, delete }
