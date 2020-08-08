import 'package:flupresso/model/Coffee.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class MachineService extends ChangeNotifier {
  static final List<String> manufacturers = [
    'Niche',
    'Decent',
    'Mahlkönig',
    'Baratza',
    'Mazzer',
    'Rancilio',
    'Eureka',
  ];

  static List<String> getManufacturersSuggestions(String query) {
    return manufacturers;
  }

  static List<String> getModelSuggestions(String query, String manufacturer) {
    //if (manufacturer != null && manufacturer != "") {
    //matches.retainWhere(
    //     (s) => s.roaster.toLowerCase().contains(roaster.toLowerCase()));
    //}
    if (manufacturer != null && manufacturer == "Niche") {
      return ["Zero"];
    }
    return [];
  }

  void notify() {
    notifyListeners();
  }

  static Future<List<Coffee>> fetchCoffees() async {
    final response = await http.get('https://coffee.mimoja.de/api/v1/coffees');

    if (response.statusCode == 200) {
      List result = await jsonDecode(response.body);
      if (result == null) {
        return List();
      }
      List coffees = result.map((e) => Coffee.fromJson(e)).toList();
      return coffees;
    } else {
      throw Exception('Failed to load Vendors');
    }
  }

  static Future<List<Coffee>> fetchmachines() async {
    final response = await http.get('https://coffee.mimoja.de/api/v1/coffees');

    if (response.statusCode == 200) {
      List result = await jsonDecode(response.body);
      if (result == null) {
        return List();
      }
      List coffees = result.map((e) => Coffee.fromJson(e)).toList();
      return coffees;
    } else {
      throw Exception('Failed to load Machines');
    }
  }
}
