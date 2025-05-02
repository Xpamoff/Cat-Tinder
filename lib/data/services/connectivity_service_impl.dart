import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/services/i_connectivity_service.dart';

class ConnectivityServiceImpl implements IConnectivityService {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
