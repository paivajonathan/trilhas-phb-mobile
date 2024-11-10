import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<(String?, String?)> loadKeys() async {
    String? userData = await _storage.read(key: "userData");
    String? token = await _storage.read(key: "token");
    return (userData, token);
  } 

  Future<void> saveKeys(String token, Map<String, dynamic> userData) async {
    await _storage.write(key: "token", value: token);
    await _storage.write(key: "userData", value: jsonEncode(userData));
  }

  Future<void> destroyKeys() async {
    await _storage.delete(key: "token");
    await _storage.delete(key: "userData");
  }
}