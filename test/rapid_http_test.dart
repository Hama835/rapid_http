import 'package:flutter_test/flutter_test.dart';
import 'package:rapid_http/rapid_http.dart';

void main() {
  group('RapidClient', () {
    late RapidClient client;

    setUp(() {
      client = RapidClient();
    });

    tearDown(() {
      client.close();
    });

    test('GET request', () async {
      final response = await client.get('https://api.example.com/data');

      expect(response.statusCode, 200);
      expect(response.body, isNotEmpty);
    });

    test('POST request', () async {
      final data = {'name': 'John Doe', 'age': '30'};
      final response =
          await client.post('https://api.example.com/users', body: data);

      expect(response.statusCode, 201);
      expect(response.body, contains('User created successfully'));
    });

    test('CacheManager', () async {
      final cacheManager = CacheManager();
      await cacheManager.writeCache(
          'https://api.example.com/data', 'Cached data');

      final cachedData =
          await cacheManager.readCache('https://api.example.com/data');

      expect(cachedData, 'Cached data');
    });

    test('ConnectivityChecker', () async {
      final connectivityChecker = ConnectivityChecker();
      final stream = connectivityChecker.connectivityStream;

      expect(await stream.first, true);
    });
  });
}
