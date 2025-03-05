import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService() {
    _checkConnectionStatus();
    _connectivity.onConnectivityChanged.listen((result) {
      _checkConnectionStatus();
    });
  }

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  Future<void> _checkConnectionStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final hasConnection =
          result.isNotEmpty && !result.contains(ConnectivityResult.none);
      _connectionStatusController.add(hasConnection);
    } on Exception {
      _connectionStatusController.add(false);
    }
  }

  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
