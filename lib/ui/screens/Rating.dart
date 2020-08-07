import 'package:flutter/material.dart';
import 'package:startup_namer/ui/Theme.dart' as Theme;
import 'package:startup_namer/ui/tab.dart';

class Rating extends StatelessWidget with TabEntry {
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
          new Text("Input Rating", style: Theme.TextStyles.tabPrimary),
          new Text("No defects detected", style: Theme.TextStyles.tabSecondary),
          new Container(
              color: Theme.Colors.tabHighlightColor,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)),
          new Row(
            children: <Widget>[
              new Icon(Icons.check_circle,
                  size: 14.0, color: Theme.Colors.goodColor),
              new Text("Flow", style: Theme.TextStyles.tabTertiary),
              new Container(width: 24.0),
              new Icon(Icons.check_circle,
                  size: 14.0, color: Theme.Colors.goodColor),
              new Text("Pressure", style: Theme.TextStyles.tabTertiary),
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
        Icons.check_circle,
        size: 55.0,
        color: Theme.Colors.primaryColor,
      ),
    );
  }
}
