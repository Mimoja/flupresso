import 'Theme.dart' as Theme;
import 'package:flutter/material.dart';

abstract class TabEntry {
  Widget getScreen(BuildContext context);
  Widget getImage(BuildContext context);
  Widget getTabContent(BuildContext context);
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
        child: entry.getImage(context),
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
        child: Row(
          children: [
            entry.getTabContent(context),
          ],
        ),
      ),
    );

    return new Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: new FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => entry.getScreen(context)),
          );
        },
        hoverColor: Theme.Colors.primaryColor,
        child: Stack(
          children: <Widget>[
            card,
            thumbnail,
          ],
        ),
      ),
    );
  }
}
