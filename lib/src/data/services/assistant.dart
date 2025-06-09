import 'dart:io';

import 'package:eventflux/eventflux.dart';

import '../../fetch_config.dart';
import '../../utils/error_handling.dart';
import '../constant/media_type.dart';
import '../exceptions/http_exception.dart';

const _pathname = 'assistant';

const _header = {
  HttpHeaders.acceptHeader: MediaType.textEventStream,
  HttpHeaders.contentTypeHeader: MediaType.applicationJsonUtf8,
};

void postQuestion(EventFlux client, void Function() onDisconnected,
    void Function(Result<Stream<EventFluxData>> result) onConnected,
    {String? newsId, required String question, required String userId}) {
  assert(userId.isNotEmpty, "User's ID is required");
  assert(question.isNotEmpty, 'Query is required');

  var url = 'http://$serverDomainName/$_pathname/chat';
  if (newsId != null) {
    url = '$url?newsId=$newsId';
  }

  final body = {
    'userId': userId,
    'question': question,
  };

  client.connect(
    EventFluxConnectionType.post,
    url,
    header: _header,
    body: body,
    onSuccessCallback: (response) {
      if (response == null) {
        return;
      }

      onConnected(Result.ok(response.stream!));
    },
    onConnectionClose: onDisconnected,
    onError: (error) {
      if (error.statusCode == null) {
        onConnected(Result.error(error));

        client.disconnect();
        return;
      }

      final httpUri = Uri.parse(url);
      final exception = switch (error.statusCode) {
        400 => HttpException.badRequest(httpUri),
        _ => HttpException(httpUri, error.statusCode!),
      };

      client.disconnect();
      onConnected(Result.error(exception));
    },
  );
}
