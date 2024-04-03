import 'package:flutter/material.dart';
import 'package:sussy_stash/store/history.dart';
import 'package:sussy_stash/page/video.dart';
import 'package:sussy_stash/widget/image.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<HistoryModel> _data = HistoryStore.get();
  final ValueNotifier<bool> _isEding = ValueNotifier(false);
  late List<ValueNotifier<bool>> _checkbox;
  final Map<String, HistoryModel> _selected = {};
  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _checkbox = _data.map((e) => ValueNotifier(false)).toList();
  }

  void _onCheck(String url) {
    int index = _data.indexWhere((element) => element.video.url == url);
    debugPrint('$index');
    debugPrint('${_checkbox[index].value}');
    if (_selected.containsKey(url)) {
      _checkbox[index].value = false;
      _selected.remove(url);
    } else {
      _checkbox[index].value = true;
      _selected[url] = _data.firstWhere((element) => element.video.url == url);
    }
  }

  void _clear() {
    for (var element in _checkbox) {
      if (element.value) {
        element.value = false;
      }
    }
    _selected.clear();
  }

  void onDelete(context) {
    for (final check in _checkbox) {
      if (check.value) {
        check.value = false;
      }
    }
    setState(() {
      List<String> urlList = [];
      List<HistoryModel> selectedList = _selected.values.toList();
      List<int> notMoveIndex =
          selectedList.map((e) => _data.indexOf(e)).toList();
      notMoveIndex.sort();
      debugPrint('$notMoveIndex');

      for (int i = selectedList.length; i > 0; i--) {
        HistoryModel selected = selectedList[i - 1];

        // for (final selected in _selected.values) {
        int index = _data.indexOf(selected);
        final tempChecked = _checkbox[index];
        _data.removeAt(index);
        _checkbox.removeAt(index);
        globalKey.currentState?.removeItem(notMoveIndex[i - 1],
            duration: const Duration(milliseconds: 300), (context, animation) {
          var item = buildListItem(context, selected, tempChecked);
          urlList.add(selected.video.url);

          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              //让透明度变化的更快一些
              curve: const Interval(0.5, 1.0),
            ),
            // 不断缩小列表项的高度
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: 0.0,
              child: item,
            ),
          );
        });
        HistoryStore.remove(selected);

        _selected.remove(selected.video.url);
      }
      // for (final url in urlList) {
      //   int index = _data.indexWhere((element) => element.video.url == url);

      // }
    });
  }

  List<Widget> buildCardText(HistoryModel model) {
    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(model.video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      const Spacer(),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(model.streamer.name,
              style: const TextStyle(fontSize: 12, color: Colors.grey))),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(model.date.toLocal().toString().split(".")[0],
              style: const TextStyle(fontSize: 12, color: Colors.grey)))
    ];
  }

  Widget buildCard(HistoryModel model, ValueNotifier<bool> isChecked) {
    return GestureDetector(
      onTap: () {
        if (_isEding.value) {
          _onCheck(model.video.url);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VideoPage(
                        video: model.video,
                        streamer: model.streamer,
                      )));
        }
      },
      onLongPress: () {
        if (_isEding.value) {
          return;
        }
        _isEding.value = true;
        _onCheck(model.video.url);
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
                    imageUrl: model.video.cover,
                  ),
                )),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildCardText(model),
            )),
            CheckboxWidget(
              onCheck: _onCheck,
              url: model.video.url,
              visible: _isEding,
              isChecked: isChecked,
            )
          ],
        ),
      ),
    );
  }

  Widget buildDeleteButton(context) {
    debugPrint('${_isEding.value}');
    return ValueListenableBuilder(
      valueListenable: _isEding,
      builder: (context, value, child) {
        return SizedBox(
            height: value ? 60 : 0,
            width: value ? 60 : 0,
            child: Stack(children: [
              AnimatedPositioned(
                curve: Curves.easeOut,
                bottom: 0,
                // opacity: value ? 1.0 : 0.0,
                left: 0,
                right: value ? 0 : -60,
                duration: const Duration(microseconds: 30000),
                child: child!,
              ),
            ]));
      },
      child: Align(
          alignment: Alignment.center,
          child: CircleAvatar(
              radius: 20,
              child: IconButton(
                onPressed: () {
                  onDelete(context);
                },
                icon: const Icon(Icons.delete),
              ))),
    );
  }

  Widget buildListItem(BuildContext context, HistoryModel historyModel,
      ValueNotifier<bool> isChecked) {
    return SizedBox(
      key: Key(historyModel.video.url),
      height: 100,
      child: buildCard(historyModel, isChecked),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史记录'),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          if (_isEding.value) {
            _clear();
            _isEding.value = false;
          } else {
            debugPrint('pop');
            Navigator.of(context).pop();
          }
        },
        // child: ListView.builder(
        //     itemCount: _data.length,
        //     itemBuilder: (context, index) {
        //       return buildListItem(context, index);
        //     }),
        child: AnimatedList(
            key: globalKey,
            initialItemCount: _data.length,
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                opacity: animation,
                child: buildListItem(context, _data[index], _checkbox[index]),
              );
            }),
      ),
      floatingActionButton: buildDeleteButton(context),
    );
  }
}

class CheckboxWidget extends StatefulWidget {
  final Function(String) onCheck;
  final String url;
  final ValueNotifier<bool> visible;
  final ValueNotifier<bool> isChecked;
  const CheckboxWidget({
    super.key,
    required this.onCheck,
    required this.url,
    required this.visible,
    required this.isChecked,
  });

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  Widget buildListenCheckbox(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.isChecked,
      builder: (context, value, child) {
        return Checkbox(
            value: value,
            onChanged: (value) {
              widget.onCheck(widget.url);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.visible,
        builder: (BuildContext context, bool value, Widget? child) {
          return SizedBox(
            height: value ? 40 : 0,
            width: value ? 40 : 0,
            child: Stack(
              children: [
                AnimatedPositioned(
                  curve: Curves.easeOut,
                  bottom: 0,
                  // opacity: value ? 1.0 : 0.0,
                  left: 0,
                  right: value ? 0 : -60,
                  duration: const Duration(microseconds: 30000),
                  child: child!,
                )
              ],
            ),
          );
        },
        child: buildListenCheckbox(context));
  }
}
