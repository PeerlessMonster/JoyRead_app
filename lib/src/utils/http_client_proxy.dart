import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

abstract class HttpClientProxy {
  Future<T> fetch<T>(Future<T> Function(http.Client client) onRequest);
}

class HttpClientProxyWithDisposableConnection extends HttpClientProxy {
  @override
  Future<T> fetch<T>(Future<T> Function(http.Client client) onRequest) async {
    final client = _spawn();
    final response = await onRequest(client);
    client.close();

    return response;
  }
}

class HttpClientProxyWithPersistentConnection extends HttpClientProxy {
  var _isClosed = false;

  final _client = _spawn();

  @override
  Future<T> fetch<T>(Future<T> Function(http.Client client) onRequest) async {
    final response = await onRequest(_client);
    return response;
  }

  void close() {
    assert(!_isClosed, 'Client has been closed');

    _client.close();
    _isClosed = true;
  }
}

RetryClient _spawn() => RetryClient(http.Client());
