import 'dart:developer';

import 'package:flupresso/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ui/homepage.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flupresso/ui/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Wakelock.enable();
  } on MissingPluginException catch (e) {
    log('Failed to set wakelock: ' + e.toString());
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<FluTheme>(create: (_) => FluTheme()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp() {
    setupServices();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<FluTheme>(context);

    return MaterialApp(
      title: 'Flupresso',
      theme: theme.themeData,
      home: HomePage(title: 'Flupresso'),
    );
  }
}
