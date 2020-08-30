import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

class AtomaxSkale {
  static Guid _service = Guid("0000FF08-0000-1000-8000-00805F9B34FB");

  static Guid _charateristic0 = Guid("0000EF80-0000-1000-8000-00805F9B34FB");
  static Guid _charateristic1 = Guid("0000EF81-0000-1000-8000-00805F9B34FB");
  static Guid _charateristic2 = Guid("0000EF82-0000-1000-8000-00805F9B34FB");
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
        _deviceService =
            services.firstWhere((s) => s.uuid == _service, orElse: null);
        if (_service == null) {
          log("Error fetching service from acaia scale");
          return;
        }

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
