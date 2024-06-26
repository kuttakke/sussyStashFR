// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.29.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// The type `StreamerVideoDetail` is not used by any `pub` functions, thus it is ignored.
// The type `StreamerVideoDetailResponse` is not used by any `pub` functions, thus it is ignored.

class Streamer {
  final StreamerType type;
  final String name;
  final String nameEn;
  final String icon;
  final String url;

  const Streamer({
    required this.type,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.url,
  });

  @override
  int get hashCode =>
      type.hashCode ^
      name.hashCode ^
      nameEn.hashCode ^
      icon.hashCode ^
      url.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Streamer &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          name == other.name &&
          nameEn == other.nameEn &&
          icon == other.icon &&
          url == other.url;
}

enum StreamerType {
  fc2,
  karaoke,
  misc,
}

class StreamerVideo {
  final String url;
  final String title;
  final String uploaded;
  final String cover;
  final String src;

  const StreamerVideo({
    required this.url,
    required this.title,
    required this.uploaded,
    required this.cover,
    required this.src,
  });

  @override
  int get hashCode =>
      url.hashCode ^
      title.hashCode ^
      uploaded.hashCode ^
      cover.hashCode ^
      src.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamerVideo &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          title == other.title &&
          uploaded == other.uploaded &&
          cover == other.cover &&
          src == other.src;
}

class StreamerVideoResponse {
  final bool ok;
  final String msg;
  final List<StreamerVideo> videos;

  const StreamerVideoResponse({
    required this.ok,
    required this.msg,
    required this.videos,
  });

  @override
  int get hashCode => ok.hashCode ^ msg.hashCode ^ videos.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamerVideoResponse &&
          runtimeType == other.runtimeType &&
          ok == other.ok &&
          msg == other.msg &&
          videos == other.videos;
}

class StreamersResponse {
  final bool ok;
  final String msg;
  final List<Streamer> streamers;

  const StreamersResponse({
    required this.ok,
    required this.msg,
    required this.streamers,
  });

  @override
  int get hashCode => ok.hashCode ^ msg.hashCode ^ streamers.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamersResponse &&
          runtimeType == other.runtimeType &&
          ok == other.ok &&
          msg == other.msg &&
          streamers == other.streamers;
}
