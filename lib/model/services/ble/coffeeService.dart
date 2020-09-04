import 'package:flutter/material.dart';

class ShotState {
  ShotState(this.sampleTime, this.groupPressure, this.groupFlow, this.mixTemp,
      this.headTemp, this.steamTemp, this.step);
  double sampleTime;
  double groupPressure;
  double groupFlow;
  double mixTemp;
  double headTemp;
  int steamTemp;
  int step;
}

class MachineState {
  MachineState(this.shot, this.coffeeState);
  ShotState shot;
  CoffeeState coffeeState;
}

enum CoffeeState { idle, espresso, water, steam }

class CoffeeService extends ChangeNotifier {
  MachineState _state = MachineState(null, CoffeeState.idle);

  CoffeeService();

  void setShot(ShotState shot) {
    this._state.shot = shot;
    notifyListeners();
  }

  void setState(CoffeeState state) {
    this._state.coffeeState = state;
    notifyListeners();
  }

  MachineState get state => this._state;
}
