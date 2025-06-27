import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  ConnectivityService() {
    // Initialize
    _init();
  }

  void _init() async {
    // Check initial connection status
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _handleConnectivityChange(result);

    // Subscribe to connectivity changes
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    bool isConnected = result != ConnectivityResult.none;
    _connectionStatusController.add(isConnected);
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
