enum Illustration {
  loading('Loading.png'),
  noNetwork('Network.png');

  final String filename;
  String get assetName => 'assets/illustrations/$filename';

  const Illustration(this.filename);
}
