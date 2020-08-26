import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flupresso/ui/screens/BrewPrint.dart';
import 'package:flupresso/ui/screens/CoffeeSelection.dart';
import 'package:flupresso/ui/screens/Graph.dart';
import 'package:flupresso/ui/screens/MachineSelection.dart';
import 'package:flupresso/ui/screens/Rating.dart';
import 'Theme.dart' as Theme;
import 'tab.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool available = false;

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              FlatButton(
                  color: Colors.blue,
                  child: Text(
                    'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    widget.flutterBlue.stopScan();
                    try {
                      await device.connect();
                    } catch (e) {
                      if (e.code != 'already_connected') {
                        throw e;
                      }
                    } finally {
                      _services = await device.discoverServices();
                    }

                    setState(() {
                      _connectedDevice = device;
                    });
                  }),
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

  ListView _buildConnectDeviceView() {
    List<Container> containers = new List<Container>();
    for (BluetoothService service in _services) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(service.uuid.toString()),
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
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    ListView list;
    if (_connectedDevice == null) {
      list = _buildListViewOfDevices();
    } else {
      list = _buildConnectDeviceView();
    }
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
