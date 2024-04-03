import 'dart:convert';

import '../src/rust/api/streamer_model.dart';
import '../util/json.dart';
import 'dart:collection';
import 'global.dart';

class HistoryModel{
  final Streamer streamer;
  final StreamerVideo video;
  final DateTime date;

  HistoryModel({
    required this.streamer,
    required this.video,
    required this.date,
  });

  factory HistoryModel.fromString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return HistoryModel(
      streamer: json2Streamer(json['streamer']),
      video: json2StreamerVideo(json['video']),
      date: DateTime.parse(json['date']),
    );
  }

  String toJsonString() {
    Map<String, dynamic> json = {
      'streamer': streamer2json(streamer),
      'video': streamerVideo2json(video),
      'date': date.toIso8601String(),
    };
    return jsonEncode(json);
  }
}



class HistoryStore {
  static const String _historyKey = 'history';
  static final _mapData = LinkedHashMap<String, HistoryModel>();
  static bool _isInitialized = false;

  static void _init() {
    if (!_isInitialized) {
      _isInitialized=true;
      // 初始化数据
      List<String>? data = App.localStorage.getStringList(_historyKey);
      if (data != null) {
        for (String jsonString in data) {
          HistoryModel model = HistoryModel.fromString(jsonString);
          _mapData[model.video.url] = model;
        }
      }
    }
  }

  static Future<void> _save() async {
    List<String> data = _mapData.values.map((model) => model.toJsonString()).toList();
    
    await App.localStorage.setStringList(_historyKey, data);
  }

  static List<HistoryModel> get() {
    _init();
    return _mapData.values.toList().reversed.toList();
  }
    
  static Future<void> add(HistoryModel model) async {
    _init();
    if (_mapData[model.video.url] != null) {
      _mapData.remove(model.video.url);
      
    }
    _mapData[model.video.url] = model;
    await _save();
  }

  static Future<void> remove(HistoryModel model) async {
    _init();
    _mapData.remove(model.video.url);
    await _save();
  }
}