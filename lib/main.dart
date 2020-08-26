import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/homepage.dart';
import 'model/CoffeeAppSettings.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CoffeeAppSettings(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeAppSettings>(
      builder: (context, setting, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}
