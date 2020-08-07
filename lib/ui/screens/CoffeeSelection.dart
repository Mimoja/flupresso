import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/ui/Theme.dart' as Theme;
import 'package:startup_namer/ui/tab.dart';

class CoffeeSelection extends StatelessWidget with TabEntry {
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

  String getRoaster() {
    return "Elemenza";
  }

  String getCoffee() {
    return "El pabloza";
  }

  String getOrigin() {
    return "Some Country";
  }

  String getPrice() {
    return "12.34€";
  }

  @override
  Widget getTabContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 95.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(getRoaster(), style: Theme.TextStyles.tabPrimary),
          new Text(getCoffee(), style: Theme.TextStyles.tabSecondary),
          new Container(
              color: Theme.Colors.tabHighlightColor,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)),
          new Row(
            children: <Widget>[
              new Icon(Icons.location_on,
                  size: 14.0, color: Theme.Colors.goodColor),
              new Text(getOrigin(), style: Theme.TextStyles.tabTertiary),
              new Container(width: 24.0),
              new Icon(Icons.flight_land,
                  size: 14.0, color: Theme.Colors.goodColor),
              new Text(getPrice(), style: Theme.TextStyles.tabTertiary),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget getScreen(BuildContext context) {
    return this;
  }

  @override
  Widget getImage(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl:
            'https://images.squarespace-cdn.com/content/5d318463e8d6c50001d160a6/1563541579731-9HESYR1NGT92L2CWRJ3X/elemenza_Logo_BoA.png?format=1500w&content-type=image%2Fpng',
        width: 65,
        height: 65,
        color: Theme.Colors.primaryColor,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
