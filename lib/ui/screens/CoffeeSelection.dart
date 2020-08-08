import 'package:cached_network_image/cached_network_image.dart';
import 'package:flupresso/model/CoffeeSelectionService.dart';
import 'package:flutter/material.dart';
import 'package:flupresso/ui/Theme.dart' as Theme;
import 'package:flupresso/ui/tab.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CoffeeSelection with TabEntry {
  @override
  Widget getTabContent() {
    return CoffeeSelectionTab();
  }

  @override
  Widget getImage() {
    return CoffeeSelectionImage();
  }

  @override
  Widget getScreen() {
    return null;
  }
}

class CoffeeSelectionImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

class CoffeeSelectionTab extends StatefulWidget {
  _CoffeeSelectionTabState createState() => _CoffeeSelectionTabState();
}

class _CoffeeSelectionTabState extends State<CoffeeSelectionTab> {
  final TextEditingController _typeAheadRoasterController =
      TextEditingController();
  final TextEditingController _typeAheadCoffeeController =
      TextEditingController();

  String _selectedRoaster;
  String _selectedCoffee;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 95.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                labelText: 'Roaster',
                labelStyle: Theme.TextStyles.tabLabel,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: Theme.TextStyles.tabPrimary,
              controller: this._typeAheadRoasterController,
            ),
            suggestionsCallback: (pattern) async {
              return CitiesService.getRoasterSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              this._typeAheadRoasterController.text = suggestion;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a roaster';
              }
            },
            onSaved: (value) => this._selectedRoaster = value,
          ),
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Coffee',
                  labelStyle: Theme.TextStyles.tabLabel,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                controller: this._typeAheadCoffeeController,
                style: Theme.TextStyles.tabSecondary),
            suggestionsCallback: (pattern) async {
              return CitiesService.getCoffeeSuggestions(
                  pattern, _selectedRoaster);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              this._typeAheadCoffeeController.text = suggestion;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a coffee';
              }
            },
            onSaved: (value) => this._selectedCoffee = value,
          ),
          new Container(
              color: Theme.Colors.tabHighlightColor,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)),
          new Row(
            children: <Widget>[
              new Icon(Icons.location_on,
                  size: 14.0, color: Theme.Colors.goodColor),
              new Text("Dummy Origin", style: Theme.TextStyles.tabTertiary),
              new Container(width: 24.0),
              new Icon(Icons.flight_land,
                  size: 14.0, color: Theme.Colors.goodColor),
              new Text("10€", style: Theme.TextStyles.tabTertiary),
            ],
          ),
        ],
      ),
    );
  }
}
