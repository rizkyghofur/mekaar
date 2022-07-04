import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CekKoneksiInternet {
  static final CekKoneksiInternet _singleton =
      new CekKoneksiInternet._internal();
  CekKoneksiInternet._internal();

  static CekKoneksiInternet getInstance() => _singleton;

  bool adaKoneksi = false;

  StreamController connectionChangeController = StreamController();

  final Connectivity _connectivity = Connectivity();
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  bool initialized() {
    return connectionChangeController.hasListener;
  }

  void _connectionChange(ConnectivityResult result) {
    _hasInternetInternetConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;
  Future<bool> _hasInternetInternetConnection() async {
    bool previousConnection = adaKoneksi;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (await InternetConnectionChecker().hasConnection) {
        adaKoneksi = true;
      } else {
        adaKoneksi = false;
      }
    } else {
      adaKoneksi = false;
    }

    if (previousConnection != adaKoneksi) {
      connectionChangeController.add(adaKoneksi);
    }
    return adaKoneksi;
  }
}
