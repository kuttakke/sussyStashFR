import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit/media_kit.dart';
import 'package:sussy_stash/page/video_list.dart';
import 'package:sussy_stash/store/favorite.dart';
import 'package:sussy_stash/widget/image.dart';
import 'package:sussy_stash/widget/more_video.dart';
import '../src/rust/api/streamer_model.dart';

import 'package:just_audio/just_audio.dart';
import 'dart:async';
import '../store/global.dart';
import '../store/history.dart';

class VideoPage extends StatefulWidget {
  final Streamer streamer;
  final StreamerVideo video;

  const VideoPage({
    super.key,
    required this.video,
    required this.streamer,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<VideoPage> with WidgetsBindingObserver {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  late AppLifecycleState lastLifecyleState;
  late StreamerVideo video;
  final ValueNotifier<bool> isAllowBackground =
      ValueNotifier(App.localStorage.getBool("isAllowBackground") ?? false);
  late Duration currentPosition;
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource playlist;
  late Timer _positionTimer;
  bool isPlaying = false;
  bool isSeeked = false;
  late Duration videoPosition;

  Future<void> changeAllowBackground() async {
    isAllowBackground.value = !isAllowBackground.value;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: isAllowBackground.value ? const Text("已开启后台播放") : const Text("已关闭后台播放"),
      ),
    );
    await App.localStorage
        .setBool("isAllowBackground", isAllowBackground.value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    video = widget.video;

    String? savedPosition = App.localStorage.getString(video.src);
    currentPosition =
        savedPosition == null ? Duration.zero : parseTime(savedPosition);
    if (currentPosition > const Duration(seconds: 10)) {
      isSeeked = true;
      player.open(Media(video.src, start: currentPosition));
    } else {
      player.open(Media(video.src));
    }
    // 添加记录
    HistoryStore.add(HistoryModel(
      streamer: widget.streamer,
      video: video,
      date: DateTime.now(),
    ));
    player.stream.playing.listen(
      (bool playing) {
        // if (playing && isFirstPlaying) {
        //   isFirstPlaying = false;
        //   player.seek(currentPosition);
        // }
        isPlaying = playing;
      },
    );
    player.stream.position.listen(
      (Duration position) {
        videoPosition = position;
      },
    );
    player.stream.error.listen((event) {
      debugPrint("!!!!!!!!!!!!");
      debugPrint('Error: $event');
      debugPrint("!!!!!!!!!!!!");
    });
    _audioPlayer = AudioPlayer();
    // Define the playlist
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: false,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: [
        AudioSource.uri(Uri.parse(video.src),
            tag: MediaItem(
                id: "1",
                title: video.title,
                artUri: Uri.parse(widget.streamer.icon))),
      ],
    );
    _audioPlayer.setAudioSource(playlist);
    initTimer();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkSeeked();
    });
  }

  Future<void> checkSeeked() async {
    if (isSeeked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("从上次位置播放"),
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player.dispose();
    _audioPlayer.dispose();
    _positionTimer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (!isPlaying || !isAllowBackground.value) {
        debugPrint("暂停了");
        return;
      }
      player.pause();
      currentPosition = videoPosition;
      _audioPlayer.seek(currentPosition);
      _audioPlayer.play();
    }
    if (state == AppLifecycleState.resumed) {
      if (!_audioPlayer.playing) {
        debugPrint("音频暂停了");
        _audioPlayer.pause();
        return;
      }
      _audioPlayer.pause();
      currentPosition = _audioPlayer.position;
      player.seek(currentPosition);
      player.play();
    }
    setState(() {
      lastLifecyleState = state;
    });
  }

  void initTimer() {
    _positionTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      bool isVideoPlaying = isPlaying;
      bool isAudioPlaying = _audioPlayer.playing;
      if (!isVideoPlaying && !isAudioPlaying) {
      } else if (isVideoPlaying) {
        currentPosition = videoPosition;
        // 更新状态或执行其他操作
      } else if (isAudioPlaying) {
        currentPosition = _audioPlayer.position;
      }
      await App.localStorage.setString(video.src, currentPosition.toString());
      // debugPrint("!!!!!!!!!!!保存了 $currentPosition.toString()");
    });
  }

  Duration parseTime(String input) {
    final parts = input.split(':');

    if (parts.length != 3) throw const FormatException('Invalid time format');

    int days;
    int hours;
    int minutes;
    int seconds;
    int milliseconds;
    int microseconds;

    {
      final p = parts[2].split('.');

      if (p.length != 2) throw const FormatException('Invalid time format');

      // If fractional seconds is passed, but less than 6 digits
      // Pad out to the right so we can calculate the ms/us correctly
      final p2 = int.parse(p[1].padRight(6, '0'));
      microseconds = p2 % 1000;
      milliseconds = p2 ~/ 1000;

      seconds = int.parse(p[0]);
    }

    minutes = int.parse(parts[1]);

    {
      int p = int.parse(parts[0]);
      hours = p % 24;
      days = p ~/ 24;
    }

    return Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds);
  }

  Widget buildVideo(BuildContext context) {
    // checkSeeked();
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          child: Video(controller: controller),
        ),
        const SizedBox(
          height: 10,
        ),
        buildStreamerDetail(),
        const SizedBox(
          height: 10,
        ),
        Padding(
            // height: 40,
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                video.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )),
        MoreVideoWidget(streamer: widget.streamer, video: video)
      ],
    );
  }

  Widget buildStreamerCard() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoListPage(
                        type: widget.streamer.type,
                        streamer: widget.streamer,
                      )));
        },
        child: SizedBox(
          height: 40,
          child: Row(children: [
            SizedBox(
                height: 40,
                width: 40,
                child: CacheImageWidget(
                    imageUrl: widget.streamer.icon, isCircle: true)),
            const SizedBox(
              width: 10,
            ),
            // Expanded(child: Text(widget.streamer.name)),
            Text(widget.streamer.name)
          ]),
        ));
  }

  Widget buildStreamerDetail() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 10,
          ),
          buildStreamerCard(),
          const Spacer(),
          Align(
              alignment: Alignment.centerRight,
              child: FavoriteButton(
                streamer: widget.streamer,
                video: video,
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget buildWidget(BuildContext context) {
    return buildVideo(context);
  }

  Widget buildMaterialCustomAudioButton(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isAllowBackground,
        builder: (context, isAllowBackground, child) {
          Widget icon;
          if (isAllowBackground) {
            icon = const Icon(
              Icons.headphones,
              color: Colors.red,
            );
          } else {
            icon = const Icon(Icons.headset_off);
          }
          return MaterialCustomButton(
            onPressed: () {
              changeAllowBackground();
            },
            icon: icon,
          );
        });
  }

  MaterialVideoControlsThemeData buildThemeData() {
    return MaterialVideoControlsThemeData(
      displaySeekBar: true,
      volumeGesture: true,
      brightnessGesture: true,
      seekGesture: true,
      gesturesEnabledWhileControlsVisible: true,
      seekOnDoubleTap: true,
      seekOnDoubleTapEnabledWhileControlsVisible: true,
      speedUpOnLongPress: true,
      bottomButtonBar: [
        const MaterialPositionIndicator(),
        const Spacer(),
        buildMaterialCustomAudioButton(context),
        const MaterialFullscreenButton()
      ],
    );
  }

  Widget buildVideoTheme(BuildContext context, Widget child) {
    MaterialVideoControlsThemeData themeData = buildThemeData();
    return // Wrap [Video] widget with [MaterialVideoControlsTheme].
        MaterialVideoControlsTheme(
            normal: themeData, fullscreen: themeData, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return buildVideoTheme(
        context,
        Scaffold(
          appBar: AppBar(
            // title: Text(video.title),
            
          ),
          body: buildWidget(context),
        ));
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(video.title),
    //   ),
    //   body: buildWidget(context),
    // );
  }
}

class FavoriteButton extends StatefulWidget {
  final Streamer streamer;
  final StreamerVideo video;
  const FavoriteButton(
      {super.key, required this.streamer, required this.video});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = FavoriteStore.isFavorite(widget.video.url);
  }

  Future<void> change() async {
    if (isFavorited) {
      await FavoriteStore.add(FavoriteModel(
          streamer: widget.streamer,
          video: widget.video,
          date: DateTime.now()));
    } else {
      await FavoriteStore.removeByUrl(widget.video.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        isSelected: isFavorited,
        icon: const Icon(Icons.favorite),
        selectedIcon: const Icon(Icons.favorite, color: Colors.red),
        onPressed: () {
          setState(() {
            isFavorited = !isFavorited;
          });
          change();
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  isFavorited ? const Text("已添加到收藏") : const Text("已从收藏中移除"),
            ),
          );
        });
  }
}
