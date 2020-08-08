import 'package:flupresso/model/Coffee.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CoffeeSelectionService extends ChangeNotifier {
  static Future<List<String>> getRoasterSuggestions(String query) async {
    List<Coffee> matches = await fetchCoffees();

    if (matches.length == 0) {
      //TODO fetch local storage?
      return List<String>();
    }

    //TODO add last used

    matches.retainWhere(
        (s) => s.roaster.toLowerCase().contains(query.toLowerCase()));
    return matches.map((e) => e.roaster).toList();
  }

  static Future<List<String>> getCoffeeSuggestions(
      String query, String roaster) async {
    List<Coffee> matches = await fetchCoffees();

    if (matches.length == 0) {
      //TODO fetch local storage?
      return List<String>();
    }

    //TODO add last used
    if (roaster != null && roaster != "") {
      matches.retainWhere(
          (s) => s.roaster.toLowerCase().contains(roaster.toLowerCase()));
    }
    matches
        .retainWhere((s) => s.name.toLowerCase().contains(query.toLowerCase()));
    return matches.map((e) => e.name).toList();
  }

  void notify() {
    notifyListeners();
  }

  static Future<List<Coffee>> fetchCoffees() async {
    final response = await http.get('https://coffee.mimoja.de/api/v1/coffees');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List result = await jsonDecode(response.body);
      if (result == null) {
        return List();
      }
      List coffees = result.map((e) => Coffee.fromJson(e)).toList();
      return coffees;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
