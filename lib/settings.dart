import 'package:flutter/cupertino.dart';

class AppSettings extends ChangeNotifier {
  bool uiEdit = true;

  void toggleUIEdit() {
    uiEdit = !uiEdit;
    notifyListeners();
  }
}
