import 'package:flupresso/ui/screens/DeviceChooser.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.Colors.tabPageBackground,
      body: ListView(
        children: <Widget>[
          CoffeeTab(CoffeeSelection()),
          CoffeeTab(MachineSelection()),
          CoffeeTab(BrewPrint()),
          CoffeeTab(Graph()),
          CoffeeTab(Rating()),
          CoffeeTab(DeviceChooser()),
          Container(
            height: 40,
          ),
        ],
      ),
    );
  }
}
