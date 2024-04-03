import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/theme.dart';
import '../store/nsfw.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  
  bool nsfw = NsfwStore.getNsfw();
  ThemeMode theme = ThemeStore.getThemeMode();
  // final NsfwProvider _nsfwProvider = NsfwProvider();
  // final ThemeProvider _themeProvider = ThemeProvider();
  late NsfwProvider _nsfwProvider;
  late ThemeProvider _themeProvider;
  late String _themeString;
  final List<String> _themeStringList = ["亮色主题", "暗色主题", "系统默认"];

  String themeModeToString(ThemeMode theme) {
    if (theme == ThemeMode.light) {
      return _themeStringList[0];
    } else if (theme == ThemeMode.dark) {
      return _themeStringList[1];
    } else {
      return _themeStringList[2];
    }
  }

  @override
  void initState() {
    _nsfwProvider = Provider.of<NsfwProvider>(context, listen: false);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _themeString = themeModeToString(theme);
    super.initState();
  }

  Future<void> _changeTheme(String themeString) async {
    if (themeString == _themeString) {
      return;
    }
    if (themeString == _themeStringList[0]) {
      setState(() {
        theme = ThemeMode.light;
        _themeString = themeModeToString(theme);
      });
      await ThemeStore.setThemeMode(theme);
      _themeProvider.setThemeMode(theme);
    } else if (themeString == _themeStringList[1]) {
      setState(() {
        theme = ThemeMode.dark;
        _themeString = themeModeToString(theme);
      });
      await ThemeStore.setThemeMode(theme);
      _themeProvider.setThemeMode(theme);
    } else {
      setState(() {
        theme = ThemeMode.system;
        _themeString = themeModeToString(theme);
      });
      await ThemeStore.setThemeMode(theme);
      _themeProvider.setThemeMode(theme);
    }
  }

  Future<void> _changeNsfw(bool value) async {
    setState(() {
      nsfw = value;
    });
    await NsfwStore.setNsfw(nsfw);
    _nsfwProvider.setNsfw(nsfw);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('NSFW'),
              value: nsfw,
              onChanged: (value) async {
                await _changeNsfw(value);
              },
              secondary: const Icon(Icons.lock),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('主题设置'),
              leading: const Icon(Icons.settings_brightness),
              trailing: DropdownButton<String>(
                value: _themeString,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (value) async {
                  await _changeTheme(value!);
                },
                items: _themeStringList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}