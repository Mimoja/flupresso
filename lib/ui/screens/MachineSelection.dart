import 'package:flupresso/model/services/suggestionServices/MachineSelectionService.dart';
import 'package:flutter/material.dart';
import 'package:flupresso/ui/Theme.dart' as Theme;
import 'package:flupresso/ui/tab.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MachineSelection with TabEntry {
  String getVendor() {
    return "Niche";
  }

  String getModel() {
    return "Zero";
  }

  @override
  Widget getScreen() {
    return null;
  }

  @override
  Widget getTabContent() {
    return MachineSelectionTab();
  }

  @override
  Widget getImage() {
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

class MachineSelectionTab extends StatefulWidget {
  _MachineSelectionTabState createState() => _MachineSelectionTabState();
}

class _MachineSelectionTabState extends State<MachineSelectionTab> {
  final TextEditingController _typeAheadManufacturerController =
      TextEditingController();
  final TextEditingController _typeAheadModelController =
      TextEditingController();

  String _selectedManufacturer;
  String _selectedModel;

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
                labelText: 'Manufacturer',
                labelStyle: Theme.TextStyles.tabLabel,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: Theme.TextStyles.tabPrimary,
              controller: this._typeAheadManufacturerController,
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
              this._typeAheadManufacturerController.text = suggestion;
              this._selectedManufacturer = suggestion;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a manufacturer';
              }
            },
            onSaved: (value) => this._selectedManufacturer = value,
          ),
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Model',
                  labelStyle: Theme.TextStyles.tabLabel,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                controller: this._typeAheadModelController,
                style: Theme.TextStyles.tabSecondary),
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
              this._typeAheadModelController.text = suggestion;
              this._selectedModel = suggestion;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a model';
              }
            },
            onSaved: (value) => this._selectedModel = value,
          ),
          new Container(
              color: Theme.Colors.tabHighlightColor,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)),
        ],
      ),
    );
  }
}
