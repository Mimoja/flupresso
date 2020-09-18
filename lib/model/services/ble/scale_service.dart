import 'dart:async';
import 'dart:developer';

class WeightMeassurement {
  double flow;
  double weight;
  WeightMeassurement(this.weight, this.flow);
}

class ScaleService {
  double _weight = 0.0;
  DateTime last;

  StreamController<WeightMeassurement> _controller;
  Stream _stream;

  ScaleService() {
    _controller = StreamController<WeightMeassurement>();
    _stream = _controller.stream.asBroadcastStream();
  }

  void setWeight(double weight) {
    log("Weight: " + weight.toString());
    var now = DateTime.now();
    double flow = 0.0;
    if (last != null) {
      var timeDiff =
          (now.millisecondsSinceEpoch - last.millisecondsSinceEpoch) / 1000;
      log(timeDiff.toStringAsFixed(2));
      flow = (weight - _weight) / timeDiff;
    }

    _controller.add(WeightMeassurement(weight, flow));
    _weight = weight;
    last = now;
  }

  Stream get stream => _stream;

  double get weight => _weight;
}
