class HttpException implements Exception {
  final Uri url;
  final int statusCode;

  const HttpException(this.url, this.statusCode);

  factory HttpException.badRequest(Uri url) => BadRequestException(url);

  factory HttpException.notFound(Uri url) => BadRequestException(url);
}

class BadRequestException extends HttpException {
  const BadRequestException(Uri url) : super(url, 400);
}

class NotFoundException extends HttpException {
  const NotFoundException(Uri url) : super(url, 404);
}
