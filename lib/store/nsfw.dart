import 'package:flutter/material.dart';
import 'global.dart';

class NsfwProvider with ChangeNotifier {
  bool isNsfwOn = false;
  bool _isInit = false;

  init() {
    if (_isInit) return;
    _isInit = true;
    isNsfwOn = NsfwStore.getNsfw();
  }

  setNsfw(bool value) {
    isNsfwOn = value;
    notifyListeners();
  }
}

class NsfwStore {
  static const _mode = "nsfw"; // 用于持久化存储的key

  
  static Future setNsfw(bool value) async {
    return await App.localStorage.setBool(
        _mode,
        value);
  }

  
  static bool getNsfw() {
    bool? result = App.localStorage.getBool(_mode);
    return result ?? false;
  }

}