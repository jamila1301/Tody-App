import 'dart:convert';
import 'dart:io';

final class JsonFileReader {
  static dynamic read(String fileName) {
    final data = File('test/json/$fileName').readAsStringSync();
    return jsonDecode(data);
  }
}
