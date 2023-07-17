part of rapid_http;

typedef Response = http.Response;

class RapidClient {
  static final RapidClient _instance = RapidClient._internal();

  factory RapidClient() {
    return _instance;
  }

  RapidClient._internal();

  Map<String, String> defaultHeaders = {};

  final connectivityChecker = ConnectivityChecker();

  void setDefaultHeader(String key, String value) {
    defaultHeaders[key] = value;
  }

  void close() {
    connectivityChecker.dispose();
  }

  Future<Response> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final response =
        await http.delete(Uri.parse(url), headers: mergedHeaders, body: body);
    return response;
  }

  Future<Response> get(String url,
      {Map<String, String>? headers, bool cacheData = false}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final isOnline = await connectivityChecker._isConnected();
    final cacheManager = CacheManager();

    if (isOnline == false && cacheData) {
      final cachedResponse = await cacheManager.readCache(url);

      if (cachedResponse != null) {
        return Response.bytes(cachedResponse.codeUnits, 200);
      }
    }

    final response = await http.get(Uri.parse(url), headers: mergedHeaders);
    if (cacheData) {
      await cacheManager.writeCache(url, response.body);
    }
    return response;
  }

  Future<Response> head(String url, {Map<String, String>? headers}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final response = await http.head(Uri.parse(url), headers: mergedHeaders);
    return response;
  }

  Future<Response> patch(String url,
      {Map<String, String>? headers, Object? body}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final response =
        await http.patch(Uri.parse(url), headers: mergedHeaders, body: body);
    return response;
  }

  Future<Response> post(String url,
      {Map<String, String>? headers, Object? body}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final response =
        await http.post(Uri.parse(url), headers: mergedHeaders, body: body);
    return response;
  }

  Future<Response> put(String url,
      {Map<String, String>? headers, Object? body}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final response =
        await http.put(Uri.parse(url), headers: mergedHeaders, body: body);
    return response;
  }

  Future<String> read(String url, {Map<String, String>? headers}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final response = await http.get(Uri.parse(url), headers: mergedHeaders);
    final responseBody = response.body;
    return responseBody;
  }

  Future<Uint8List> readBytes(String url,
      {Map<String, String>? headers}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final response = await http.get(Uri.parse(url), headers: mergedHeaders);
    final responseBytes = response.bodyBytes;
    return responseBytes;
  }

  Future<Response> postFormData(String url,
      {Map<String, String>? headers,
      Map<String, String>? fields,
      Map<String, File>? files}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Add fields to the request
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Add files to the request
    if (files != null) {
      files.forEach((key, file) async {
        final stream = http.ByteStream(Stream.castFrom(file.openRead()));
        final length = await file.length();
        final multipartFile = http.MultipartFile(
          key, // Use the provided key instead of hardcoding 'file'
          stream,
          length,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      });
    }

    request.headers.addAll(mergedHeaders);

    final response = await request.send();
    final streamedResponse = await Response.fromStream(response);
    return streamedResponse;
  }
}
