import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectivityStream;
  Future<ConnectivityResult> get connectionType;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnectionActive(result.first);
  }

  @override
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged
        .map((results) => _isConnectionActive(results.first));
  }

  @override
  Future<ConnectivityResult> get connectionType async {
    final result = await _connectivity.checkConnectivity();
    return result.first;
  }

  bool _isConnectionActive(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
      case ConnectivityResult.none:
        return false;
    }
  }

  // Get connection quality estimation
  Future<ConnectionQuality> getConnectionQuality() async {
    final result = await connectionType;
    
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        return ConnectionQuality.high;
      case ConnectivityResult.mobile:
        return ConnectionQuality.medium;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.other:
        return ConnectionQuality.low;
      case ConnectivityResult.vpn:
        return ConnectionQuality.medium;
      case ConnectivityResult.none:
        return ConnectionQuality.none;
    }
  }

  // Check if connection is suitable for heavy operations
  Future<bool> isSuitableForHeavyOperations() async {
    final quality = await getConnectionQuality();
    return quality == ConnectionQuality.high || quality == ConnectionQuality.medium;
  }
}

enum ConnectionQuality {
  none,
  low,
  medium,
  high,
}

// Connectivity module registration
abstract class ConnectivityModule {
    Connectivity get connectivity => Connectivity();
}