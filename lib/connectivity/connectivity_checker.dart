part of rapid_http;

class ConnectivityChecker {
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => _connectivityController.stream;

  bool _lastConnectivityState = true;

  ConnectivityChecker() {
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    final initialConnectivity = await _isConnected();
    _connectivityController.add(initialConnectivity);
    _lastConnectivityState = initialConnectivity;
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    Timer.periodic(const Duration(seconds: 1), (time) async {
      final currentConnectivity = await _isConnected();
      if (_lastConnectivityState != currentConnectivity) {
        _connectivityController.add(currentConnectivity);
        _lastConnectivityState = currentConnectivity;
      }
    });
  }

  Future<bool> _isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && (result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }

  void dispose() {
    _connectivityController.close();
  }
}
