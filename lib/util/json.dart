import '../src/rust/api/streamer_model.dart';

final Map<String, StreamerType> _typeMap = {
  'fc2': StreamerType.fc2,
  'karaoke': StreamerType.karaoke,
  'misc': StreamerType.misc
};

Map<String, dynamic> streamerVideo2json(StreamerVideo video) {
  return {
    'url': video.url,
    'title': video.title,
    'uploaded': video.uploaded,
    'cover': video.cover,
    'src': video.src,
  };
}

StreamerVideo json2StreamerVideo(Map<String, dynamic> json) {
  return StreamerVideo(
    url: json['url'],
    title: json['title'],
    uploaded: json['uploaded'],
    cover: json['cover'],
    src: json['src'],
  );
}

Map<String, dynamic> streamer2json(Streamer streamer) {
  return {
    'type': streamer.type.name,
    'name': streamer.name,
    'name_en': streamer.nameEn,
    'icon': streamer.icon,  
    'url': streamer.url,
  };
}

Streamer json2Streamer(Map<String, dynamic> json) {
  return Streamer(
    type: _typeMap[json['type']] ?? StreamerType.misc,
    name: json['name'],
    nameEn: json['name_en'],
    icon: json['icon'],
    url: json['url'],
  );
}

Map<String, dynamic> streamersResponse2json(StreamersResponse response) {
  return {
    'ok': response.ok,
    'msg': response.msg,
    'streamers': response.streamers.map((e) => streamer2json(e)).toList(),
  };
}

StreamersResponse json2StreamersResponse(Map<String, dynamic> json) {
  return StreamersResponse(
    ok: json['ok'],
    msg: json['msg'],
    streamers:
        (json['streamers'] as List).map((e) => json2Streamer(e)).toList(),
  );
}

Map<String, dynamic> streamerVideoResponse2json(StreamerVideoResponse response) {
  return {
    'ok': response.ok,
    'msg': response.msg,
    'videos': response.videos.map((e) => streamerVideo2json(e)).toList(),
  };
}

StreamerVideoResponse json2StreamerVideoResponse(Map<String, dynamic> json) {
  return StreamerVideoResponse(
    ok: json['ok'],
    msg: json['msg'],
    videos: (json['videos'] as List).map((e) => json2StreamerVideo(e)).toList(),
  );
}

