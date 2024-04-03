import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sussy_stash/page/favorite.dart';
import 'package:sussy_stash/page/history.dart';
import 'page/config.dart';
import 'widget/category_card.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'store/theme.dart';
import 'store/global.dart';
import 'store/nsfw.dart';
import 'package:media_kit/media_kit.dart';
// import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:sussy_stash/src/rust/frb_generated.dart';
import 'src/rust/api/streamer_model.dart' as model;

void main() async {
  RustLib.init();
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  await Future.wait([
    JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
    App.init(),
    App.initColor()
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => NsfwProvider(),
        )
        // 其他需要在整个应用程序中共享的 Providers
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

  // This widget is the root of your application.
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, ThemeProvider provider, child) {
      debugPrint(provider.themeMode.toString());
      provider.init();
      return MaterialApp(
        title: 'SUSSY-STASH-FR',
        theme: ThemeData(
          colorScheme: App.colorScheme,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: App.colorScheme.primary,
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: provider.themeMode,
        home: const MyHomePage(title: 'SUSSY-STASH-FR'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<model.StreamerType, String> imageMap = {
    model.StreamerType.fc2: 'asset/cover_fc2.jpg',
    model.StreamerType.karaoke: 'asset/cover_kar.jpg',
    model.StreamerType.misc: 'asset/cover_misc.jpg',
  };
  // bool _isNsfw = NsfwStore.getNsfw();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("asset/bg_draw.jpg"), fit: BoxFit.fill)
                  // color: Colors.blue,
                  ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('历史记录'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
              }
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('收藏夹'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // Invalid constant value
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FavoritePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('设置'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // Invalid constant value
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ConfigPage()));
              },
            ),
          ],
        ),
      ),
      body: Consumer<NsfwProvider>(
        builder: (context, NsfwProvider provider, child) {
          provider.init();
          if (!provider.isNsfwOn) {
            return ListView(
              children: imageMap.entries
                  .where((element) => element.key != model.StreamerType.fc2)
                  .map((e) {
                return CategoryWidget(
                  type: e.key,
                  image: e.value,
                );
              }).toList(),
            );
          } else {
            return ListView(
              children: imageMap.entries.map((e) {
                return CategoryWidget(
                  type: e.key,
                  image: e.value,
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
