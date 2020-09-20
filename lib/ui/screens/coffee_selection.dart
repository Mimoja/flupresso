import 'package:cached_network_image/cached_network_image.dart';
import 'package:flupresso/model/services/state/coffee_service.dart';
import 'package:flupresso/model/services/state/machine_service.dart';
import 'package:flupresso/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class CoffeeSelection {
  Widget getTabContent() {
    return CoffeeSelectionTab();
  }

  Widget getImage() {
    return CoffeeSelectionImage();
  }
}

class CoffeeSelectionImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<FluTheme>(context);
    return Center(
      child: CachedNetworkImage(
        imageUrl:
            'https://images.squarespace-cdn.com/content/5d318463e8d6c50001d160a6/1563541579731-9HESYR1NGT92L2CWRJ3X/elemenza_Logo_BoA.png?format=1500w&content-type=image%2Fpng',
        width: 65,
        height: 65,
        color: theme.primaryColor,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}

class CoffeeSelectionTab extends StatefulWidget {
  @override
  _CoffeeSelectionTabState createState() => _CoffeeSelectionTabState();
}

class _CoffeeSelectionTabState extends State<CoffeeSelectionTab> {
  final TextEditingController _typeAheadRoasterController =
      TextEditingController();
  final TextEditingController _typeAheadCoffeeController =
      TextEditingController();

  String _selectedRoaster;
  //String _selectedCoffee;

  CoffeeService coffeeService;
  MachineService machineService;

  @override
  void initState() {
    super.initState();
    coffeeService = getIt<CoffeeService>();
    machineService = getIt<MachineService>();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<FluTheme>(context);

    return Container(
      margin: const EdgeInsets.only(left: 95.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                labelText: 'Roaster',
                labelStyle: theme.tabLabelStyle,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: theme.tabPrimaryStyle,
              controller: _typeAheadRoasterController,
            ),
            suggestionsCallback: (pattern) async {
              return coffeeService.getRoasterSuggestions(pattern);
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
              _typeAheadRoasterController.text = suggestion;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a roaster';
              }
              return null;
            },
            onSaved: (value) => _selectedRoaster = value,
          ),
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Coffee',
                  labelStyle: theme.tabLabelStyle,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                controller: _typeAheadCoffeeController,
                style: theme.tabSecondaryStyle),
            suggestionsCallback: (pattern) async {
              return coffeeService.getCoffeeSuggestions(
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
              _typeAheadCoffeeController.text = suggestion;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a coffee';
              }
              return null;
            },
            //onSaved: (value) => this._selectedCoffee = value,
          ),
          Container(
              color: theme.backgroundColor,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)),
          Row(
            children: <Widget>[
              Icon(Icons.location_on,
                  size: 14.0, color: theme.goodColor),
              Text('Dummy Origin', style: theme.tabTertiaryStyle),
              Container(width: 24.0),
              Icon(Icons.flight_land,
                  size: 14.0, color: theme.goodColor),
              Text('10€', style: theme.tabTertiaryStyle),
            ],
          ),
        ],
      ),
    );
  }
}
