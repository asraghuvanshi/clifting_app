import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternetConnection() async {
    final connectivityResult =
     await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

Stream<ConnectivityResult> connectivityStream() {
  return Connectivity().onConnectivityChanged.map((event) => event.first);
}
}