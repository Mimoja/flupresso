import 'package:flupresso/model/services/ble/bluetoothService.dart';
import 'package:flupresso/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flupresso/ui/screens/BrewPrint.dart';
import 'package:flupresso/ui/screens/CoffeeSelection.dart';
import 'package:flupresso/ui/screens/Graph.dart';
import 'package:flupresso/ui/screens/MachineSelection.dart';
import 'package:flupresso/ui/screens/Rating.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'Theme.dart' as Theme;
import 'tab.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool available = false;

  ListView _buildListViewOfDevices(List<Peripheral> devicesList) {
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
                        device.name == null ? '(unknown device)' : device.name),
                    Text(device.identifier.toString()),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BLEService ble = getIt<BLEService>();

    ListView list = _buildListViewOfDevices(ble.devices);

    return Scaffold(
      backgroundColor: Theme.Colors.tabPageBackground,
      body: ListView(
        children: <Widget>[
          CoffeeTab(CoffeeSelection()),
          CoffeeTab(MachineSelection()),
          CoffeeTab(BrewPrint()),
          CoffeeTab(Graph()),
          CoffeeTab(Rating()),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: list,
          ),
          Container(
            height: 40,
          ),
        ],
      ),
    );
  }
}
