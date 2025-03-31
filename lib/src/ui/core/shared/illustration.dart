enum Illustration {
  loading("加载中……", 'Loading.png'),
  noNetwork("Unable to access network.", 'Network.png');

  final String text;
  final String filename;
  String get assetName => 'assets/illustrations/$filename';

  const Illustration(this.text, this.filename);
}
