import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

RetryClient _create() => RetryClient(http.Client());

class HttpClientProxyWithDisposableConnection extends HttpClientProxy {
  @override
  Future<T> fetch<T>(Future<T> Function(http.Client client) request) async {
    final client = _create();
    final response = await request(client);
    client.close();

    return response;
  }
}

class HttpClientProxyWithPersistentConnection extends HttpClientProxy {
  var _isClosed = false;

  final _client = RetryClient(http.Client());

  @override
  Future<T> fetch<T>(Future<T> Function(http.Client client) request) async {
    final response = await request(_client);
    return response;
  }

  void close() {
    assert(!_isClosed, 'Client has been closed');

    _client.close();
    _isClosed = true;
  }
}

abstract class HttpClientProxy {
  Future<T> fetch<T>(Future<T> Function(http.Client client) request);
}
