import 'package:flutter/material.dart';
import 'global.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool _isInit = false;

  init() {
    if (_isInit) return;
    _isInit = true;
    themeMode = ThemeStore.getThemeMode();
  }


  setThemeMode(ThemeMode mode) {
    themeMode = mode;
    debugPrint("主题模式已设置为：$themeMode");
    notifyListeners();
  }
}

class ThemeStore {
  static const _mode = "theme_mode"; // 用于持久化存储的key

  /// 将 [ThemeMode] 映射成 [int] 类型
  static const Map<int, ThemeMode> modeMap = {
    0: ThemeMode.system,
    1: ThemeMode.light,
    2: ThemeMode.dark,
  };

  /// 设置主题模式
  static Future setThemeMode(ThemeMode themeMode) async {
    return await App.localStorage.setInt(
        _mode,
        modeMap.entries
            .firstWhere(((element) => element.value == themeMode))
            .key);
  }

  /// 获取主题模式
  static ThemeMode getThemeMode() {
    int? result = App.localStorage.getInt(_mode);
    return modeMap[modeMap.keys.contains(result) ? result : 0]!;
  }
}
