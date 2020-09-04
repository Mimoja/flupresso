import 'package:flupresso/model/services/ble/bluetoothService.dart';
import 'package:flupresso/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flupresso/ui/Theme.dart' as Theme;
import 'package:flupresso/ui/tab.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class DeviceChooser extends StatefulWidget with TabEntry {
  @override
  _DeviceChooserState createState() => _DeviceChooserState();

  @override
  Widget getTabContent() {
    return this;
  }

  @override
  Widget getImage() {
    return Center(
      child: new Icon(
        Icons.check_circle,
        size: 55.0,
        color: Theme.Colors.primaryColor,
      ),
    );
  }
}

class _DeviceChooserState extends State<DeviceChooser> {
  BLEService ble;

  _DeviceChooserState() {
    ble = getIt<BLEService>();
    ble.addListener(() => setState(() => {}));
  }
  @override
  Widget build(BuildContext context) {
    ListView list = _buildListViewOfDevices(ble.devices);
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300),
          child: list,
        ),
        RaisedButton(
            child: Text(
              "Rescan",
              style: Theme.TextStyles.tabSecondary,
            ),
            onPressed: ble.startScanning),
      ],
    );
  }

  Widget _buildListViewOfDevices(List<Peripheral> devicesList) {
    List<Container> containers = new List<Container>();
    for (Peripheral device in devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      device.name == null ? '(unknown device)' : device.name,
                      style: Theme.TextStyles.tabTertiary,
                    ),
                    Text(device.identifier.toString(),
                        style: Theme.TextStyles.tabTertiary),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }
}
