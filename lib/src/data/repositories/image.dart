import '../services/image.dart';

class ImageUrlRepository {
  const ImageUrlRepository();

  String loadNews(String filename) => joinNewsImageUrl(filename);
}
