import 'dart:async';
import 'dart:developer';
import 'dart:math' show pow;
import 'dart:typed_data';

import 'package:flupresso/model/services/ble/scale_service.dart';
import 'package:flupresso/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class AcaiaScale extends ChangeNotifier {
  static const String ServiceUUID = "00001820-0000-1000-8000-00805f9b34fb";
  static const String CharateristicUUID =
      "00002a80-0000-1000-8000-00805f9b34fb";
  ScaleService scaleService;

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
    9, // length
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

  final Peripheral device;

  PeripheralConnectionState _state;

  List<int> commandBuffer = List();
  Timer _heartBeatTimer;

  AcaiaScale(this.device) {
    scaleService = getIt<ScaleService>();

    device
        .observeConnectionState(
            emitCurrentValue: false, completeOnDisconnect: true)
        .listen((connectionState) {
      log("Peripheral ${device.identifier} connection state is $connectionState");
      _onStateChange(connectionState);
    });
    device.connect();
  }

  Uint8List encode(int msgType, List<int> payload) {
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

    return Uint8List.fromList(buffer);
  }

  void parsePayload(int type, List<int> payload) {
    switch (type) {
      case 12:
        int subType = payload[0];
        if (subType == 5) {
          int temp = ((payload[4] & 0xff) << 24) +
              ((payload[3] & 0xff) << 16) +
              ((payload[2] & 0xff) << 8) +
              (payload[1] & 0xff);
          int unit = payload[5] & 0xFF;

          double value = temp / pow(10, unit);
          if ((payload[6] & 0x02) != 0) {
            value *= -1.0;
          }
          scaleService.setWeight(value);

          break;
        }
        //log("Unparsed acaia event subtype: " + subType.toString());
        //log("Payload: " + payload.toString());

        break;
      // General Status including battery
      case 8:
        int batteryLevel = commandBuffer[4];
        log('Got status message, battery= ' + batteryLevel.toString());
        break;
      default:
        log("Unparsed acaia response: " + type.toString());
    }
  }

  void _notificationCallback(CharacteristicWithValue wrapper) {
    var notification = wrapper.value;
    commandBuffer.addAll(notification);

    // remove broken half commands
    if (commandBuffer.length > 2 &&
        (commandBuffer[0] != HEADER1 || commandBuffer[1] != HEADER2)) {
      commandBuffer.clear();
      return;
    }
    if (commandBuffer.length > 4) {
      int type = commandBuffer[2];
      parsePayload(type, commandBuffer.sublist(4));
      commandBuffer.clear();
    }
  }

  _sendHeatbeat() {
    if (_state != PeripheralConnectionState.connected) {
      log("Disconnected from acaia scale. Not sending heartbeat");
      return;
    }
    device.writeCharacteristic(
        ServiceUUID, CharateristicUUID, encode(0x00, _heartbeatPayload), false);
  }

  _sendIdent() {
    if (_state != PeripheralConnectionState.connected) {
      log("Disconnected from acaia scale. Not sending ident");
      return;
    }
    device.writeCharacteristic(
        ServiceUUID, CharateristicUUID, encode(0x0b, _identPayload), false);
    log("Ident payload: " + encode(0x0b, _identPayload).toString());
  }

  _sendConfig() {
    if (_state != PeripheralConnectionState.connected) {
      log("Disconnected from acaia scale. Not sending config");
      return;
    }
    device.writeCharacteristic(
        ServiceUUID, CharateristicUUID, encode(0x0c, _configPayload), false);
    log("Config payload: " + encode(0x0c, _configPayload).toString());
  }

  _onStateChange(PeripheralConnectionState state) async {
    log("State changed to " + state.toString());
    _state = state;

    switch (state) {
      case PeripheralConnectionState.connected:
        await device.discoverAllServicesAndCharacteristics();

        device
            .monitorCharacteristic(ServiceUUID, CharateristicUUID)
            .listen(_notificationCallback);

        new Timer(Duration(seconds: 1), _sendIdent);
        new Timer(Duration(seconds: 2), _sendConfig);

        _heartBeatTimer =
            new Timer.periodic(_heartbeat_time, (Timer t) => _sendHeatbeat());
        return;
      case PeripheralConnectionState.disconnected:
        log("Acaia Scale disconnected. Destroying");
        device.disconnectOrCancelConnection();
        _heartBeatTimer?.cancel();
        notifyListeners();
        return;
      default:
        return;
    }
  }
}
