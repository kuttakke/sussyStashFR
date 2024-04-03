import 'package:shared_preferences/shared_preferences.dart';
// 保存配置项
Future<void> saveConfig(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
// 读取配置项
Future<String?> loadConfig(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> getNsfw() async {
  final prefs = await SharedPreferences.getInstance();
  bool? nsfw = prefs.getBool('nsfw');
  if (nsfw == null) {
    prefs.setBool('nsfw', false);
    return false;
  }
  return nsfw;
}

Future<void> changeNsfw(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('nsfw', value);
}

