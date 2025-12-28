import 'package:internet_connection_checker/internet_connection_checker.dart';


class NetworkChecker {
  Future<bool> hasInternet() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }
}
