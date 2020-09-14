import 'dart:developer';

import 'package:flupresso/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/Homepage.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Wakelock.enable();
  } on MissingPluginException catch (e) {
    log("Failed to set wakelock: " + e.toString());
  }

  setupServices();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flupresso',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Flupresso'),
    );
  }
}
