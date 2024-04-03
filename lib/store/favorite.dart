import 'dart:convert';

import '../src/rust/api/streamer_model.dart';
import '../util/json.dart';
import 'dart:collection';
import 'global.dart';

class FavoriteModel{
  final Streamer streamer;
  final StreamerVideo video;
  final DateTime date;

  FavoriteModel({
    required this.streamer,
    required this.video,
    required this.date,
  });

  factory FavoriteModel.fromString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return FavoriteModel(
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

class Diffs {
  final List<FavoriteModel> needAdd;
  final List<FavoriteModel> needRemove;

  Diffs({required this.needAdd, required this.needRemove});
}

class FavoriteStore {
  static const String _key = 'favorite';
  static final _mapData = LinkedHashMap<String, FavoriteModel>();
  static bool _isInitialized = false;

  static void _init() {
    if (!_isInitialized) {
      _isInitialized=true;
      // 初始化数据
      List<String>? data = App.localStorage.getStringList(_key);
      if (data != null) {
        for (String jsonString in data) {
          FavoriteModel model = FavoriteModel.fromString(jsonString);
          _mapData[model.video.url] = model;
        }
      }
    }
  }

  static Future<void> _save() async {
    List<String> data = _mapData.values.map((model) => model.toJsonString()).toList();
    
    await App.localStorage.setStringList(_key, data);
  }

  static List<FavoriteModel> get() {
    _init();
    return _mapData.values.toList().reversed.toList();
  }
    
  static Future<void> add(FavoriteModel model) async {
    _init();
    if (_mapData[model.video.url] != null) {
      _mapData.remove(model.video.url);
      
    }
    _mapData[model.video.url] = model;
    await _save();
  }

  static Future<void> remove(FavoriteModel model) async {
    _init();
    _mapData.remove(model.video.url);
    await _save();
  }

  static Future<void> removeByUrl(String url) async {
    _init();
    _mapData.remove(url);
    await _save();
  }

  static bool isFavorite(String url) {
    _init();
    return _mapData[url] != null;
  }

  // 返回需要删除的model和需要添加的model
  static Diffs checkDiffs(List<FavoriteModel> models) {
    _init();
    List<FavoriteModel> needRemove = [];
    
    final LinkedHashMap<String, FavoriteModel> mapDataCopy = LinkedHashMap.from(_mapData);
    
    for (FavoriteModel model in models) {
      if (_mapData[model.video.url] == null) {
        needRemove.add(model);
      } else {
        
        if (model.date != _mapData[model.video.url]!.date) {
          needRemove.add(model);
          // needAdd.add(_mapData[model.video.url]!);
        } else {
          mapDataCopy.remove(model.video.url);
        }
        }
      }
    
    return Diffs(
      needAdd: mapDataCopy.values.toList(),
      needRemove: needRemove,
    );
  }
}