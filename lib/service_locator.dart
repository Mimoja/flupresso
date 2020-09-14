import 'package:flupresso/model/services/ble/bluetoothService.dart';
import 'package:flupresso/model/services/ble/scaleService.dart';
import 'package:flupresso/model/services/ble/MachineService.dart';
import 'package:flupresso/model/services/state/CoffeeService.dart';
import 'package:flupresso/model/services/state/MachineService.dart';
import 'package:flupresso/model/services/state/ProfileService.dart';

import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupServices() {
  getIt.registerSingleton<BLEService>(BLEService(), signalsReady: false);
  getIt.registerSingleton<ScaleService>(ScaleService(), signalsReady: false);
  getIt.registerSingleton<CoffeeService>(CoffeeService(), signalsReady: false);
  getIt.registerSingleton<MachineService>(MachineService(),
      signalsReady: false);
  getIt.registerSingleton<ProfileService>(ProfileService(),
      signalsReady: false);
  getIt.registerSingleton<EspressoMachineService>(EspressoMachineService(),
      signalsReady: false);
}
