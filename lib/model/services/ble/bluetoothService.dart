import 'dart:developer';

import 'package:flupresso/model/acaia_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BLEService extends ChangeNotifier {
  FlutterBlue flutterBlue;
  List<BluetoothDevice> _devicesList = new List<BluetoothDevice>();
  List<BluetoothDevice> _scales = new List<BluetoothDevice>();

  BLEService() {
    /// lets pretend we have to do some async initilization
    //Future.delayed(Duration(seconds: 3)).then((_) => getIt.signalReady(this));
    /*flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });*/
    flutterBlue = FlutterBlue.instance;
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();
  }

  List<BluetoothDevice> get devices => _devicesList;
  List<BluetoothDevice> get scales => _scales;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!_devicesList.contains(device) && !_scales.contains(device)) {
      if (device.name.startsWith("ACAIA")) {
        log("Creating Acaia Scale!");
        AcaiaScale(device);
        _scales.add(device);
        flutterBlue.stopScan();
      }
      _devicesList.add(device);
      notifyListeners();
    }
  }
}
