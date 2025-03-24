import '../services/image.dart';

class ImageUrlRepository {
  const ImageUrlRepository();

  String news(String filename) => joinNewsImageUrl(filename);
}
