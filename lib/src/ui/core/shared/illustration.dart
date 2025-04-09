enum Illustration {
  loading("加载中……", 'Loading.png'),
  noNetwork("Unable to access network.", 'Network.png');

  final String description;
  final String filename;
  String get assetName => 'assets/illustrations/$filename';

  const Illustration(this.description, this.filename);
}
