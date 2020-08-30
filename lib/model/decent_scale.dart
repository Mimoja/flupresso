import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

class AtomaxSkale {
  static Guid _service = Guid("0000FFF0-0000-1000-8000-00805F9B34FB");

  static Guid _charateristic_read =
      Guid("0000FFF4-0000-1000-8000-00805F9B34FB");
  static Guid _charateristic_write =
      Guid("000036F5-0000-1000-8000-00805F9B34FB");

  final BluetoothDevice device;

  BluetoothService _deviceService;
  BluetoothCharacteristic _deviceCharacteristic;
  BluetoothDeviceState _state;

  List<int> commandBuffer = List();

  AtomaxSkale(this.device) {
    device.state.listen(_onStateChange);

    connectIfNeeded();
  }

  connectIfNeeded() async {
    _state = await device.state.last;
    if (_state != BluetoothDeviceState.connected) {
      log("Connecting to acaia scale!");
      device.connect();
    }
  }

  _onStateChange(BluetoothDeviceState state) async {
    log("State changed to " + state.toString());
    _state = state;

    switch (state) {
      case BluetoothDeviceState.connected:
        List<BluetoothService> services = await device.discoverServices();

        return;
      case BluetoothDeviceState.disconnected:
        log("reconnecintg");
        connectIfNeeded();
        return;
      default:
        return;
    }
  }
}
