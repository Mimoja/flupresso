import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:startup_namer/ui/screens/BrewPrint.dart';
import 'package:startup_namer/ui/screens/CoffeeSelection.dart';
import 'package:startup_namer/ui/screens/Graph.dart';
import 'package:startup_namer/ui/screens/MachineSelection.dart';
import 'package:startup_namer/ui/screens/Rating.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.Colors.tabPageBackground,
        body: ListView(
          children: <Widget>[
            CoffeeTab(CoffeeSelection()),
            CoffeeTab(MachineSelection()),
            CoffeeTab(BrewPrint()),
            CoffeeTab(Graph()),
            CoffeeTab(Rating()),
            Container(
              height: 40,
            ),
          ],
        ),
      );
}
