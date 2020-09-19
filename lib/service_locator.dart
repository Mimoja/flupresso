import 'package:flupresso/model/services/ble/ble_service.dart';
import 'package:flupresso/model/services/ble/scale_service.dart';
import 'package:flupresso/model/services/ble/machine_service.dart';
import 'package:flupresso/model/services/state/coffee_service.dart';
import 'package:flupresso/model/services/state/machine_service.dart';
import 'package:flupresso/model/services/state/profile_service.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

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
