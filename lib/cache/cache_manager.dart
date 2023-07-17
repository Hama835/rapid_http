part of rapid_http;

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();

  factory CacheManager() {
    return _instance;
  }

  CacheManager._internal();

  Future<void> writeCache(String key, String data) async {
    final cacheDir = await getTemporaryDirectory();
    final fileName = md5.convert(utf8.encode(key)).toString(); // Hash the key
    final cacheFile = File('${cacheDir.path}/$fileName');
    await cacheFile.writeAsString(data);
  }

  Future<String?> readCache(String key) async {
    final cacheDir = await getTemporaryDirectory();
    final fileName = md5.convert(utf8.encode(key)).toString();
    final cacheFile = File('${cacheDir.path}/$fileName');
    if (await cacheFile.exists()) {
      return await cacheFile.readAsString();
    }
    return null;
  }

  Future<void> clearCache() async {
    final cacheDir = await getTemporaryDirectory();
    final cacheFiles = cacheDir.listSync();
    for (final file in cacheFiles) {
      if (file is File) {
        await file.delete();
      }
    }
  }
}
