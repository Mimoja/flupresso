import 'package:flutter/material.dart';
import 'package:startup_namer/ui/Theme.dart' as Theme;
import 'package:startup_namer/ui/tab.dart';

class BrewPrint extends StatelessWidget with TabEntry {
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

  String getGramsIn() {
    return "18 grams in";
  }

  String getGramsOut() {
    return "38 grams out";
  }

  String getBasket() {
    return "18g basket";
  }

  String getTemperature() {
    return "94°C";
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
          new Text(getGramsIn(), style: Theme.TextStyles.tabPrimary),
          new Text(getGramsOut(), style: Theme.TextStyles.tabSecondary),
          new Container(
              color: Theme.Colors.tabHighlightColor,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)),
          new Row(
            children: <Widget>[
              new Icon(Icons.add_circle_outline,
                  size: 14.0, color: Theme.Colors.primaryColor),
              new Text(getBasket(), style: Theme.TextStyles.tabTertiary),
              new Container(width: 24.0),
              new Icon(Icons.location_on,
                  size: 14.0, color: Theme.Colors.secondaryColor),
              new Text(getTemperature(), style: Theme.TextStyles.tabTertiary),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget getImage(BuildContext context) {
    return Center(
      child: new Icon(
        Icons.local_cafe,
        size: 45.0,
        color: Theme.Colors.primaryColor,
      ),
    );
  }
}
