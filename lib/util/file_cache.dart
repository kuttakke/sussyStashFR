import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// The DefaultCacheManager that can be easily used directly. The code of
/// this implementation can be used as inspiration for more complex cache
/// managers.
class MyDefaultCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'libCachedImageData';

  static final MyDefaultCacheManager _instance = MyDefaultCacheManager._();

  factory MyDefaultCacheManager() {
    return _instance;
  }

  MyDefaultCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 1),
          maxNrOfCacheObjects: 60,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ));
}