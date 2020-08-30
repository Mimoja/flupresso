import 'package:flupresso/service_locator.dart';
import 'package:flutter/material.dart';
import 'ui/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
