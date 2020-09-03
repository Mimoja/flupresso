import 'dart:collection';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';

enum Endpoint {
  Versions,
  RequestedState,
  SetTime,
  ShotDirectory,
  ReadFromMMR,
  WriteToMMR,
  ShotMapRequest,
  DeleteShotRange,
  FWMapRequest,
  Temperatures,
  ShotSettings,
  DeprecatedShotDesc,
  ShotSample,
  StateInfo,
  HeaderWrite,
  FrameWrite,
  WaterLevels,
  Calibration
}

class DE1 {
  static const String ServiceUUID = "0000A000-0000-1000-8000-00805F9B34FB";

  static var cuuids = {
    "0000A001-0000-1000-8000-00805F9B34FB": Endpoint.Versions,
    "0000A002-0000-1000-8000-00805F9B34FB": Endpoint.RequestedState,
    "0000A003-0000-1000-8000-00805F9B34FB": Endpoint.SetTime,
    "0000A004-0000-1000-8000-00805F9B34FB": Endpoint.ShotDirectory,
    "0000A005-0000-1000-8000-00805F9B34FB": Endpoint.ReadFromMMR,
    "0000A006-0000-1000-8000-00805F9B34FB": Endpoint.WriteToMMR,
    "0000A007-0000-1000-8000-00805F9B34FB": Endpoint.ShotMapRequest,
    "0000A008-0000-1000-8000-00805F9B34FB": Endpoint.DeleteShotRange,
    "0000A009-0000-1000-8000-00805F9B34FB": Endpoint.FWMapRequest,
    "0000A00A-0000-1000-8000-00805F9B34FB": Endpoint.Temperatures,
    "0000A00B-0000-1000-8000-00805F9B34FB": Endpoint.ShotSettings,
    "0000A00C-0000-1000-8000-00805F9B34FB": Endpoint.DeprecatedShotDesc,
    "0000A00D-0000-1000-8000-00805F9B34FB": Endpoint.ShotSample,
    "0000A00E-0000-1000-8000-00805F9B34FB": Endpoint.StateInfo,
    "0000A00F-0000-1000-8000-00805F9B34FB": Endpoint.HeaderWrite,
    "0000A010-0000-1000-8000-00805F9B34FB": Endpoint.FrameWrite,
    "0000A011-0000-1000-8000-00805F9B34FB": Endpoint.WaterLevels,
    "0000A012-0000-1000-8000-00805F9B34FB": Endpoint.Calibration
  };

  static Map<Endpoint, String> cuuidLookup = LinkedHashMap.fromEntries(
      cuuids.entries.map((e) => MapEntry(e.value, e.key)));

  final Peripheral device;
  PeripheralConnectionState _state;

  var identifier = new Map();

  bool mmrAvailable = false;

  DE1(this.device) {
    device
        .observeConnectionState(
            emitCurrentValue: true, completeOnDisconnect: false)
        .listen((connectionState) {
      print(
          "Peripheral ${device.identifier} connection state is $connectionState");
      _onStateChange(connectionState);
    });

    connectIfNeeded();
  }

  connectIfNeeded() async {
    log("Connecting to acaia if needed");
    if (_state != PeripheralConnectionState.connected) {
      log("Connecting to acaia scale!");
      device.connect();
    }
  }

  _onStateChange(PeripheralConnectionState state) async {
    log("State changed to " + state.toString());
    _state = state;

    switch (state) {
      case PeripheralConnectionState.connected:
        return;
      case PeripheralConnectionState.disconnected:
        log("reconnecintg");
        connectIfNeeded();
        return;
      default:
        return;
    }
  }

  String getCharacteristic(Endpoint e) {
    return cuuidLookup[e];
  }

  read(Endpoint e) {
    device.readCharacteristic(ServiceUUID, getCharacteristic(e));
  }

  write(Endpoint e, Uint8List data) {
    device.writeCharacteristic(ServiceUUID, getCharacteristic(e), data, false);
  }

  enable(Endpoint e) {
    device
        .monitorCharacteristic(ServiceUUID, getCharacteristic(e))
        .listen((event) {});
  }

  disable(Endpoint e) {
    // ?
  }

  mmrRead(int adress, int length) {
    if (!mmrAvailable) {
      log("Unable to mmr_read because MMR not available");
      return;
    }
    var data = new List<int>.filled(3, 0, growable: false);
  }
}
