import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:flutter_blue/flutter_blue.dart';

Color darkenColor(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

class HomePageGradient extends LinearGradient {
  HomePageGradient({Color color, bool darken = true})
      : super(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.97, 1.0],
          colors: [
            color,
            darken ? darkenColor(color, 0.15) : color,
          ],
        );
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                onPressed: () {},
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
  Widget build(BuildContext context) => Scaffold(
        body: _buildListViewOfDevices(),
      );
}

/*
SingleChildScrollView(
          child: Column(
            children: <Widget>[
              
              Container(
                decoration: BoxDecoration(
                  gradient: HomePageGradient(
                      color: coffeeSelectionBackground1, darken: false),
                ),
                child: ExpansionTile(
                  title: Container(child: Text("  ")),
                  children: [
                    Text(
                      "test",
                      style: TextStyle(color: secondaryColor),
                    ),
                    Text(
                      "test",
                      style: TextStyle(color: secondaryColor),
                    ),
                    Text(
                      "test",
                      style: TextStyle(color: secondaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient:
                        HomePageGradient(color: coffeeSelectionBackground2)),
                height: 300,
                child: Center(
                  child: Text("Profile"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: HomePageGradient(color: coffeeSelectionBackground3),
                ),
                height: 300,
                child: Center(
                  child: Text("Graph"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: HomePageGradient(color: coffeeSelectionBackground4),
                ),
                height: 300,
                child: Center(
                  child: Text("Water / Steam"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: HomePageGradient(color: coffeeSelectionBackground4),
                ),
                height: 300,
                child: Center(
                  child: Text("Settings"),
                ),
              )
            ],
          ),
        ),
        */
