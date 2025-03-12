import 'dart:convert';

T jsonDecodeTo<T>(
    String source, T Function(Map<String, dynamic> json) constructor) {
  final json = jsonDecode(source) as Map<String, dynamic>;
  return constructor(json);
}

List<T> jsonDecodeToList<T>(
    String source, T Function(Map<String, dynamic> json) constructor) {
  final jsonList = (jsonDecode(source) as List).cast<Map<String, dynamic>>();
  return jsonList.map((json) => constructor(json)).toList();
}
