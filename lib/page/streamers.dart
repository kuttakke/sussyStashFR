import 'package:flutter/material.dart';
import '../widget/image.dart';
import 'video_list.dart';
import '../store/global.dart';
import 'dart:convert';
import '../src/rust/api/streamer_model.dart';
import '../src/rust/api/streamer_api.dart';
import '../util/json.dart';

class StreamersPage extends StatefulWidget {
  final StreamerType category;
  const StreamersPage({super.key, required this.category});

  @override
  State<StatefulWidget> createState() {
    return _StreamersState();
  }
}

class _StreamersState extends State<StreamersPage> {
  final ValueNotifier<StreamersResponse?> response = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    StreamersResponse? cacheData = loadStreamers();
    if (cacheData != null) {
      response.value = cacheData;
    }
    get();
  }

  bool isResponeEqual(StreamersResponse a, StreamersResponse b) {
    return jsonEncode(streamersResponse2json(a)) == jsonEncode(streamersResponse2json(b));
  }
  Future<void> get() async {
    // GetStreamer(type: widget.category).sendSignalToRust(null);
    final responseData = await getCategory(type: widget.category);
    if (response.value != null && isResponeEqual(response.value!, responseData)) {
      debugPrint("use cache data");
      return;
    }

    response.value = responseData;
    if (responseData.ok == true) {
      saveStreamers(widget.category, responseData);
    }
  }

  Future<void> saveStreamers(
      StreamerType type, StreamersResponse respone) async {
    await App.localStorage.setString(
        "type-${type.name}", jsonEncode(streamersResponse2json(respone)));
  }

  StreamersResponse? loadStreamers() {
    String? json = App.localStorage.getString("type-${widget.category.name}");
    if (json == null) return null;
    var jsonData = jsonDecode(json);
    return json2StreamersResponse(jsonData);
    // return StreamersResponse.fromJson(jsonDecode(json));
    // (jsonDecode(json));
  }

  Widget buildStreamer(StreamersResponse respone) {
    return RefreshIndicator(
        onRefresh: get,
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(respone.streamers.length, (index) {
            return StreamerWidget(
              category: widget.category,
              streamer: respone.streamers[index],
            );
          }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name),
        ),
        body: ValueListenableBuilder(
            valueListenable: response,
            builder: (context, value, child) {
              if (value == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (value.ok == false) {
                return Center(
                    child: Column(
                  children: [const Text('获取错误'), Text(value.msg)],
                ));
              } else if (value.streamers.isEmpty) {
                return const Center(child: Text('获取错误'));
              } else {
                return buildStreamer(value);
              }
            }));
  }
}

class StreamerWidget extends StatelessWidget {
  final StreamerType category;
  final Streamer streamer;

  const StreamerWidget(
      {super.key, required this.streamer, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VideoListPage(type: category, streamer: streamer))),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Expanded(
                child: CacheImageWidget(
                  imageUrl: streamer.icon,
                  isCircle: true,
                ),
              ),
              Center(
                child: Text(streamer.name),
              ),
              Center(
                child: Text(
                  streamer.nameEn,
                  style: const TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ));
  }
}
