import 'package:flupresso/model/services/ble/bluetoothService.dart';
import 'package:flupresso/model/services/ble/scaleService.dart';
import 'package:flupresso/model/services/ble/coffeeService.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupServices() {
  getIt.registerSingleton<BLEService>(BLEService(), signalsReady: false);
  getIt.registerSingleton<ScaleService>(ScaleService(), signalsReady: false);
  getIt.registerSingleton<CoffeeService>(CoffeeService(), signalsReady: false);
}
