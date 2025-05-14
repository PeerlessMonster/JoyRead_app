enum Avatar {
  user('emoji.png');

  final String fileName;
  String get assetName => 'assets/avatar/$fileName';

  const Avatar(this.fileName);
}
