import 'dart:convert';

import 'package:flutter/material.dart';
import 'video.dart';
import '../widget/image.dart';
import '../store/global.dart';
import '../src/rust/api/streamer_model.dart';
import '../src/rust/api/streamer_api.dart';
import '../util/json.dart';

class VideoListPage extends StatefulWidget {
  final StreamerType type;
  final Streamer streamer;

  const VideoListPage({super.key, required this.type, required this.streamer});

  @override
  State<StatefulWidget> createState() {
    return _VideoListState();
  }
}

class _VideoListState extends State<VideoListPage> {
  // late List<StreamerVideo> videoList;
  final ValueNotifier<StreamerVideoResponse?> respone = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    StreamerVideoResponse? cacheData = loadStreamerVideos();
    if (cacheData != null) {
      respone.value = cacheData;
    }
    get();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isResponeEqual(StreamerVideoResponse a, StreamerVideoResponse b) {
    return jsonEncode(streamerVideoResponse2json(a)) == jsonEncode(streamerVideoResponse2json(b));
  }

  Future<void> get() async {
    final responeData = await getVideos(url: widget.streamer.url);
    if (respone.value != null && isResponeEqual(responeData, respone.value!)) {
      debugPrint('respone is equal');
      return;
    }
    respone.value = responeData;
    if (responeData.ok == true) {
      saveStreamerVideos(responeData);
    }
  }

  Future<void> saveStreamerVideos(
      StreamerVideoResponse respone) async {
    await App.localStorage
        .setString(widget.streamer.url, jsonEncode(streamerVideoResponse2json(respone)));
  }

  StreamerVideoResponse? loadStreamerVideos() {
    String? json = App.localStorage.getString(widget.streamer.url);
    if (json == null) return null;
    return json2StreamerVideoResponse(jsonDecode(json));
  }

  Widget buildVideo(StreamerVideoResponse respone) {
    return RefreshIndicator(
      onRefresh: get,
      child: GridView.builder(
          itemCount: respone.videos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return VideoCard(
              video: respone.videos[index],
              streamer: widget.streamer,
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.streamer.name),
        ),
    body: ValueListenableBuilder(
      valueListenable: respone,
      builder: (context, value, child) {
        if (value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (value.ok == false) {
          return Center(
                    child: Column(
                  children: [const Text('获取错误'), Text(value.msg)],
                ));
        } else if (value.videos.isEmpty) {
          return const Center(child: Text('获取错误'));
        } else {
          return buildVideo(value);
        }
      },
    )
    );
  }
}

class VideoCard extends StatelessWidget {
  final StreamerVideo video;
  final Streamer streamer;

  const VideoCard({super.key, required this.video, required this.streamer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VideoPage(
                      video: video,
                      streamer: streamer,
                    ))),
        child: GridTile(
            child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  height: 100,
                  child: CacheImageWidget(
                    imageUrl: video.cover,
                  )),
              Text(video.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                  
              const Spacer(),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    video.uploaded,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.grey),
                  )),
            ],
          ),
        )));
  }
}
