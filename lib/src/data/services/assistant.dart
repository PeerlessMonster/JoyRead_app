import 'dart:io';

import 'package:eventflux/eventflux.dart';

import '../../fetch_config.dart';
import '../../utils/error_handling.dart';
import '../constant/media_type.dart';
import '../exceptions/http_exception.dart';

const _pathname = 'assistant';

void postChat(EventFlux client,
    void Function(Result<Stream<EventFluxData>> result) onConnected,
    {required String question, required String userId}) {
  assert(userId.isNotEmpty, "User's ID is required");
  assert(question.isNotEmpty, 'Query is required');

  final url = 'http://$serverDomainName/$_pathname/chat';

  const header = {
    HttpHeaders.acceptHeader: MediaType.textEventStream,
    HttpHeaders.contentTypeHeader: MediaType.applicationJsonUtf8,
  };
  final body = {
    'userId': userId,
    'question': question,
  };

  client.connect(
    EventFluxConnectionType.post,
    url,
    header: header,
    body: body,
    onSuccessCallback: (response) {
      if (response == null) {
        return;
      }
      onConnected(Result.ok(response.stream!));
    },
    onError: (error) {
      if (error.statusCode == null) {
        onConnected(Result.error(error));
        return;
      }

      final exception = switch (error.statusCode) {
        400 => HttpException.badRequest(Uri.parse(url)),
        _ => HttpException(Uri.parse(url), error.statusCode!),
      };
      onConnected(Result.error(exception));
    },
  );
}
