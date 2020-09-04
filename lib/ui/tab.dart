import 'Theme.dart' as Theme;
import 'package:flutter/material.dart';

abstract class TabEntry {
  Widget getImage();
  Widget getTabContent();
}

class CoffeeTab extends StatelessWidget {
  final TabEntry entry;

  CoffeeTab(this.entry);
  @override
  Widget build(BuildContext context) {
    final thumbnail = Container(
      decoration: BoxDecoration(
        color: Theme.Colors.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: Theme.Dimens.imageWidth,
        height: Theme.Dimens.imageHeight,
        decoration: BoxDecoration(
          color: Theme.Colors.tabImageBackground,
          shape: BoxShape.circle,
        ),
        child: entry.getImage(),
      ),
    );

    final card = Container(
      margin: const EdgeInsets.only(left: 30.0, right: 24.0, top: 10),
      decoration: new BoxDecoration(
        color: Theme.Colors.tabBackground,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(15.0),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 16.0, left: 0.0, bottom: 20.0),
        child: entry.getTabContent(),
      ),
    );

    Widget inner = FlatButton(
      onPressed: null,
      child: Stack(
        children: <Widget>[
          card,
          thumbnail,
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: inner,
    );
  }
}
