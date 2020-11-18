import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String SECURE_NOTE_KEY = "SECURE_NOTE_KEY";

class UserData with ChangeNotifier {
  String username;

  UserData({this.username});

  String get getUsername {
    return this.username;
  }

  void setUsername(_username) {
    this.username = _username;
    notifyListeners();
  }
}

class Storage with ChangeNotifier {
  final _storage = FlutterSecureStorage();
  List<_SecItem> _items = [];

  void addNewItem(String _value) async {
    await _storage.write(key: SECURE_NOTE_KEY, value: _value);
  }

  List<_SecItem> get item {
    return _items;
  }

  void deleteAll() async {
    await _storage.deleteAll();
  }

  void delItem(String value) async {
    await _storage.delete(key: SECURE_NOTE_KEY);
  }

  Future<String> getItem(String value) async {
    String rslt = await _storage.read(key: SECURE_NOTE_KEY);
    return rslt;
  }
}

class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}
