import 'package:flutter/material.dart';
import 'package:sussy_stash/page/video.dart';
import 'package:sussy_stash/src/rust/api/streamer_api.dart';

import 'package:sussy_stash/widget/image.dart';
import '../src/rust/api/streamer_model.dart';

class MoreVideoWidget extends StatefulWidget {
  final Streamer streamer;
  final StreamerVideo video;
  const MoreVideoWidget(
      {super.key, required this.streamer, required this.video});

  @override
  State<StatefulWidget> createState() {
    return _MoreVideoWidgetState();
  }
}

enum ExpandedState {
  collapsed,
  loading,
  expanded,
}

class _MoreVideoWidgetState extends State<MoreVideoWidget> {
  final ValueNotifier<ExpandedState> _expanded =
      ValueNotifier(ExpandedState.collapsed);
  bool _isInit = false;
  final ValueNotifier<StreamerVideoResponse?> respone = ValueNotifier(null);

  Future<void> _fetchVideoResponse() async {
    _expanded.value = ExpandedState.loading;
    final responeData = await getMoreVideos(url: widget.video.url);
    debugPrint(responeData.toString());
    debugPrint(
        "More Video Response!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!/n!!!!!!!!!!!!");
    if (responeData.ok == true) {
      debugPrint("Ok Response!!!!!!!!!!/n!!!!!!!!!!!!");
      respone.value = responeData;
      _isInit = true;
      _expanded.value = ExpandedState.expanded;
    } else {
      debugPrint("Error Response!!!!!!!!!!/n!!!!!!!!!!!!");
      debugPrint(responeData.msg);
    }
  }

  Widget buildTrailing(BuildContext context) {
    return ValueListenableBuilder<ExpandedState>(
        valueListenable: _expanded,
        builder: (context, isExpanded, child) {
          if (isExpanded == ExpandedState.collapsed) {
            return const Icon(Icons.keyboard_arrow_down);
          } else if (isExpanded == ExpandedState.loading) {
            return const CircularProgressIndicator();
          } else {
            return const Icon(Icons.keyboard_arrow_up);
          }
        });
  }

  List<Widget> buildCardText(StreamerVideo model) {
    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(model.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      const Spacer(),
      // const SizedBox(height: 30),
      Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            model.uploaded,
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: Colors.grey),
          )),
    ];
  }

  Widget buildCard(StreamerVideo model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VideoPage(
                      video: model,
                      streamer: widget.streamer,
                    )));
      },
      child: Card(
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 80,
                  width: 136,
                  child: CacheImageWidget(
                    imageUrl: model.cover,
                  ),
                )),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildCardText(model),
            )),
          ],
        ),
      ),
    );
  }

  Widget buildExpansionTile(List<Widget> children) {
    return ExpansionTile(
      title: const Text('More',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      trailing: buildTrailing(context),
      children: children,
      onExpansionChanged: (value) {
        if (value == true && _isInit == false) {
          _fetchVideoResponse();
          return;
        }

        _expanded.value =
            value ? ExpandedState.expanded : ExpandedState.collapsed;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    Expanded(child:     SingleChildScrollView(
      child: ValueListenableBuilder<StreamerVideoResponse?>(
        valueListenable: respone,
        builder: (context, response, child) {
          if (response == null) {
            // return const Center(child: CircularProgressIndicator());
            return buildExpansionTile([]);
          }
          return buildExpansionTile(buildVideoList(context));
        },
      ),
    ))
;
  }

  List<Widget> buildVideoList(BuildContext context) {
    return respone.value?.videos.map((e) {
          return SizedBox(height: 100, child: buildCard(e),)
          ;
        }).toList() ??
        [];
  }
}
