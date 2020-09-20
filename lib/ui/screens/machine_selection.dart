import 'package:flupresso/model/services/state/machine_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class MachineSelection {}

class MachineSelectionTab extends StatefulWidget {
  @override
  _MachineSelectionTabState createState() => _MachineSelectionTabState();
}

class _MachineSelectionTabState extends State<MachineSelectionTab> {
  final TextEditingController _typeAheadManufacturerController =
      TextEditingController();
  final TextEditingController _typeAheadModelController =
      TextEditingController();

  String _selectedManufacturer;
  //String _selectedModel;

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
                labelText: 'Manufacturer',
                labelStyle: theme.tabLabelStyle,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: theme.tabPrimaryStyle,
              controller: _typeAheadManufacturerController,
            ),
            suggestionsCallback: (pattern) async {
              return MachineService.getVendorSuggestions(pattern);
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
              _typeAheadManufacturerController.text = suggestion;
              _selectedManufacturer = suggestion;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a manufacturer';
              }
              return null;
            },
            onSaved: (value) => _selectedManufacturer = value,
          ),
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Model',
                  labelStyle: theme.tabLabelStyle,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                controller: _typeAheadModelController,
                style: theme.tabSecondaryStyle),
            suggestionsCallback: (pattern) async {
              return MachineService.getModellSuggestions(
                  pattern, _selectedManufacturer);
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
              _typeAheadModelController.text = suggestion;
              //this._selectedModel = suggestion;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a model';
              }
              return null;
            },
            //onSaved: (value) => this._selectedModel = value,
          ),
          Container(
              color: theme.backgroundColor,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)),
        ],
      ),
    );
  }
}
