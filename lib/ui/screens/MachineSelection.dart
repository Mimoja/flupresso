import 'package:flutter/material.dart';
import 'package:startup_namer/ui/Theme.dart' as Theme;
import 'package:startup_namer/ui/tab.dart';

class MachineSelection extends StatelessWidget with TabEntry {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }

  String getVendor() {
    return "Niche";
  }

  String getModel() {
    return "Zero";
  }

  @override
  Widget getScreen(BuildContext context) {
    return this;
  }

  @override
  Widget getTabContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 95.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(getVendor(), style: Theme.TextStyles.tabPrimary),
          new Text(getModel(), style: Theme.TextStyles.tabSecondary),
          new Container(
              color: Theme.Colors.tabHighlightColor,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)),
          new Container(height: 10.0),
        ],
      ),
    );
  }

  @override
  Widget getImage(BuildContext context) {
    return Center(
      child: Container(
        child: Image.network(
          ('https://www.nichecoffee.co.uk/wp-content/uploads/2017/12/Outline_Circle_Black_Logo.png'),
          width: 75,
          height: 75,
          fit: BoxFit.scaleDown,
          color: Theme.Colors.primaryColor,
        ),
      ),
    );
  }
}
