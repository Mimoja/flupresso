import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

class AcaiaScale {
  static Guid _service = Guid("00001820-0000-1000-8000-00805f9b34fb");
  static Guid _charateristic = Guid("00002a80-0000-1000-8000-00805f9b34fb");
  static const _heartbeat_time = const Duration(seconds: 3);
  static const List<int> _heartbeatPayload = [0x02, 0x00];
  static const List<int> _identPayload = [
    0x30,
    0x31,
    0x32,
    0x33,
    0x34,
    0x35,
    0x36,
    0x37,
    0x38,
    0x39,
    0x30,
    0x31,
    0x32,
    0x33,
    0x34
  ];
  static const List<int> _configPayload = [
    0, // weight
    1, // weight argument
    1, // battery
    2, // battery argument
    2, // timer
    5, // timer argument
    3, // key
    4 // setting
  ];
  static const int HEADER1 = 0xef;
  static const int HEADER2 = 0xdd;

  final BluetoothDevice device;

  BluetoothService _deviceService;
  BluetoothCharacteristic _deviceCharacteristic;
  BluetoothDeviceState _state;

  List<int> commandBuffer = List();

  AcaiaScale(this.device) {
    device.state.listen(_onStateChange);

    connectIfNeeded();
  }

  connectIfNeeded() async {
    log("Connecting to acaia if needed");
    _state = await device.state.last;
    if (_state != BluetoothDeviceState.connected) {
      log("Connecting to acaia scale!");
      device.connect();
    }
  }

  List<int> encode(int msgType, List<int> payload) {
    int cksum1 = 0;
    int cksum2 = 0;
    List<int> buffer = List();
    buffer.add(HEADER1);
    buffer.add(HEADER2);
    buffer.add(msgType);

    payload.asMap().forEach((index, value) => {
          if (index % 2 == 0) {cksum1 += value} else {cksum2 += value},
          buffer.add(value)
        });

    buffer.add(cksum1 & 0xFF);
    buffer.add(cksum2 & 0xFF);

    return buffer;
  }

  void _notificationCallback(List<int> notification) {
    commandBuffer.addAll(notification);

    // remove broken half commands
    if (commandBuffer.length > 2 &&
        (commandBuffer[0] != HEADER1 || commandBuffer[1] != HEADER2)) {
      commandBuffer.clear();
      return;
    }
    if (commandBuffer.length > 4) {
      int type = commandBuffer[2];
      int length = commandBuffer[3];
      log("Got message type: " +
          type.toString() +
          " length: " +
          length.toString());
      commandBuffer.clear();
    }
  }

  _sendHeatbeat() {
    if (_state != BluetoothDeviceState.connected ||
        _deviceCharacteristic == null ||
        _deviceService == null) {
      log("Disconnected from acaia scale. Not sending heartbeat");
      return;
    }
    log("sending hearbeat");
    try {
      _deviceCharacteristic.write(encode(0x00, _heartbeatPayload),
          withoutResponse: true);
    } on Exception catch (e) {
      log("heartbeat write failed!");
    }
  }

  _sendIdent() {
    if (_state != BluetoothDeviceState.connected ||
        _deviceCharacteristic == null ||
        _deviceService == null) {
      log("Disconnected from acaia scale. Not sending ident");
      return;
    }
    try {
      _deviceCharacteristic.write(encode(0x0b, _identPayload),
          withoutResponse: true);
    } on Exception catch (e) {
      log("Ident write failed!");
    }
  }

  _sendConfig() {
    if (_state != BluetoothDeviceState.connected ||
        _deviceCharacteristic == null ||
        _deviceService == null) {
      log("Disconnected from acaia scale. Not sending config");
      return;
    }
    try {
      _deviceCharacteristic.write(encode(0x0c, _configPayload),
          withoutResponse: false);
    } catch (e) {
      log("Config write failed!");
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
        _deviceCharacteristic = _deviceService.characteristics
            .firstWhere((c) => c.uuid == _charateristic, orElse: null);
        if (_deviceCharacteristic == null) {
          log("Error fetching characteristic from acaia scale");
          return;
        }

        CharacteristicProperties props = _deviceCharacteristic.properties;
        if (!props.writeWithoutResponse) {
          log("Cannot write characterisitic");
          return;
        }
        if (!props.notify) {
          log("Cannot notify characterisitic");
          return;
        }

        device.requestMtu(223);
        _deviceCharacteristic.setNotifyValue(true);
        _deviceCharacteristic.value.listen(_notificationCallback);

        new Timer(Duration(seconds: 1), _sendIdent());
        new Timer(Duration(seconds: 1, milliseconds: 500), _sendConfig());

        new Timer.periodic(_heartbeat_time, (Timer t) => _sendHeatbeat());
        return;
      case BluetoothDeviceState.disconnected:
        log("reconnecintg");
        device.connect();
        return;
      default:
        return;
    }
  }
}
