import 'package:flupresso/model/services/ble/bluetoothService.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupServices() {
  getIt.registerSingleton<BLEService>(BLEService(), signalsReady: false);
}
