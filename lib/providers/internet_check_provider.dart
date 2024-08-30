import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sky_scrapper/models/internet_check_model.dart';

class InternetCheckProvider with ChangeNotifier {
  InternetCheckModel internetCheckModel =
      InternetCheckModel(isNetworkAvailable: false);
  void checkConnectivity() {
    Connectivity connectivity = Connectivity();
    Stream<List<ConnectivityResult>> stream =
        connectivity.onConnectivityChanged;

    stream.listen(
      (List<ConnectivityResult> result) {
        if (result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.mobile)) {
          internetCheckModel.isNetworkAvailable = true;
        } else {
          internetCheckModel.isNetworkAvailable = false;
        }
        notifyListeners();
      },
    );
  }
}
