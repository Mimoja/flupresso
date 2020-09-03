import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:flupresso/devices/acaia_scale.dart';
import 'package:flupresso/devices/decent_de1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class BLEService extends ChangeNotifier {
  static BleManager bleManager = BleManager();

  List<Peripheral> _devicesList = new List<Peripheral>();
  PermissionStatus _locationPermissionStatus;

  BLEService() {
    init();
  }

  void init() async {
    await bleManager.createClient();
    bleManager.observeBluetoothState().listen(btStateListener);
    startScanning();
  }

  void btStateListener(BluetoothState btState) {
    print(btState);
  }

  void deviceScanListener(ScanResult result) {
    print("Scanned Peripheral ${result.peripheral.name}, RSSI ${result.rssi}");
    _addDeviceTolist(result.peripheral);
  }

  List<Peripheral> get devices => _devicesList;

  void startScanning() {
    var sub = bleManager.startPeripheralScan().listen(deviceScanListener);
    Timer(Duration(seconds: 10), () {
      bleManager.stopPeripheralScan();
      sub.cancel();
    });
  }

  void _checkdevice(Peripheral device) async {
    if (!await device.isConnected()) {
      log("Removing device");
      bleManager.startPeripheralScan();
    }
  }

  _addDeviceTolist(final Peripheral device) async {
    if (!_devicesList.map((e) => e.identifier).contains(device.identifier)) {
      if (!await device.isConnected() &&
          device.name != null &&
          device.name.startsWith("ACAIA")) {
        log("Creating Acaia Scale!");
        AcaiaScale(device).addListener(() => _checkdevice(device));
      }
      if (device.name != null && device.name.startsWith("DE1")) {
        log("Creating DE1 machine!");
        DE1(device);
      }
      _devicesList.add(device);
      notifyListeners();
    }
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      var permissionStatus = await PermissionHandler()
          .requestPermissions([PermissionGroup.location]);

      _locationPermissionStatus = permissionStatus[PermissionGroup.location];

      if (_locationPermissionStatus != PermissionStatus.granted) {
        return Future.error(Exception("Location permission not granted"));
      }
    }
  }
}
