import '../../fetch_config.dart';

const _objectStorageRoute = 'images';

String generateNewsImageUrl(String filename) =>
    'http://$serverDomainName/$_objectStorageRoute/news/contents/$filename';
