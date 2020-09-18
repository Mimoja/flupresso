import 'package:flupresso/model/services/ble/machine_service.dart';
import 'package:flupresso/model/services/ble/scale_service.dart';
import 'package:flupresso/service_locator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flupresso/ui/theme.dart' as Theme;

class WaterScreen extends StatefulWidget {
  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  EspressoMachineService machineService;
  ScaleService scaleService;

  double _currentTemperature = 60;
  double _currentAmount = 100;
  double _currentSteamAutoOff = 45;
  double _currentFlushAutoOff = 15;

  @override
  void initState() {
    super.initState();
    machineService = getIt<EspressoMachineService>();
    machineService.addListener(() {
      setState(() {});
    });

    // Scale services is consumed as stream
    scaleService = getIt<ScaleService>();
  }

  List<ShotState> dataPoints = List();

  List<charts.Series<ShotState, double>> _createData() {
    return [
      new charts.Series<ShotState, double>(
        id: 'Pressure',
        domainFn: (ShotState point, _) => point.sampleTime,
        measureFn: (ShotState point, _) => point.groupPressure,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Theme.Colors.backgroundColor),
        strokeWidthPxFn: (_, __) => 3,
        data: dataPoints,
      ),
      new charts.Series<ShotState, double>(
        id: 'Flow',
        domainFn: (ShotState point, _) => point.sampleTime,
        measureFn: (ShotState point, _) => point.groupFlow,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Theme.Colors.secondaryColor),
        strokeWidthPxFn: (_, __) => 3,
        data: dataPoints,
      ),
    ];
  }

  Widget _buildWaterControl() {
    return ButtonBar(
      children: [
        Text(
          "Water:",
          style: Theme.TextStyles.tabPrimary,
        ),
        RaisedButton(
          color: Theme.Colors.goodColor,
          child: Text(
            "-5",
            style: Theme.TextStyles.tabSecondary,
          ),
          onPressed: () {
            setState(() {
              _currentAmount = _currentAmount - 5;
            });
          },
        ),
        Slider(
          value: _currentAmount,
          min: 0,
          max: 250,
          divisions: ((250 - 0) / 5).round(),
          label: _currentAmount.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentAmount = value;
            });
          },
        ),
        RaisedButton(
          color: Theme.Colors.goodColor,
          child: Text(
            "+5",
            style: Theme.TextStyles.tabSecondary,
          ),
          onPressed: () {
            setState(() {
              _currentAmount = _currentAmount + 5;
            });
          },
        ),
      ],
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
    );
  }

  Widget _buildSteamConrol() {
    return ButtonBar(
      children: [
        Text(
          "Steam Timeout: ",
          style: Theme.TextStyles.tabPrimary,
        ),
        RaisedButton(
          color: Theme.Colors.goodColor,
          child: Text(
            "-1",
            style: Theme.TextStyles.tabSecondary,
          ),
          onPressed: () {
            setState(() {
              _currentSteamAutoOff = _currentSteamAutoOff - 1;
            });
          },
        ),
        Slider(
          value: _currentSteamAutoOff,
          min: 0,
          max: 100,
          divisions: ((100 - 0) / 1).round(),
          label: _currentSteamAutoOff.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSteamAutoOff = value;
            });
          },
        ),
        RaisedButton(
          color: Theme.Colors.goodColor,
          child: Text(
            "+1",
            style: Theme.TextStyles.tabSecondary,
          ),
          onPressed: () {
            setState(() {
              _currentSteamAutoOff = _currentSteamAutoOff + 1;
            });
          },
        ),
      ],
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
    );
  }

  Widget _buildTemperaturControl() {
    return ButtonBar(
      children: [
        Text(
          "Water Temperature: ",
          style: Theme.TextStyles.tabPrimary,
        ),
        RaisedButton(
          color: Theme.Colors.goodColor,
          child: Text(
            "-1",
            style: Theme.TextStyles.tabSecondary,
          ),
          onPressed: () {
            setState(() {
              _currentTemperature = _currentTemperature - 1;
            });
          },
        ),
        Slider(
          value: _currentTemperature,
          min: 20,
          max: 100,
          divisions: 80,
          label: _currentTemperature.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentTemperature = value;
            });
          },
        ),
        RaisedButton(
          color: Theme.Colors.goodColor,
          child: Text(
            "+1",
            style: Theme.TextStyles.tabSecondary,
          ),
          onPressed: () {
            setState(() {
              _currentTemperature = _currentTemperature + 1;
            });
          },
        ),
      ],
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
    );
  }

  Widget _buildFlushControl() {
    return ButtonBar(
      children: [
        Text(
          "Flush Timeout: ",
          style: Theme.TextStyles.tabPrimary,
        ),
        RaisedButton(
          color: Theme.Colors.goodColor,
          child: Text(
            "-1",
            style: Theme.TextStyles.tabSecondary,
          ),
          onPressed: () {
            setState(() {
              _currentFlushAutoOff = _currentFlushAutoOff - 1;
            });
          },
        ),
        Slider(
          value: _currentFlushAutoOff,
          min: 0,
          max: 180,
          divisions: ((180 - 0)).round(),
          label: _currentFlushAutoOff.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentFlushAutoOff = value;
            });
          },
        ),
        RaisedButton(
          color: Theme.Colors.goodColor,
          child: Text(
            "+1",
            style: Theme.TextStyles.tabSecondary,
          ),
          onPressed: () {
            setState(() {
              _currentFlushAutoOff = _currentFlushAutoOff + 1;
            });
          },
        ),
      ],
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
    );
  }

  Widget _buildGraph() {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(left: 10.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: new BoxDecoration(
        color: Theme.Colors.tabColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
      ),
      child: charts.LineChart(
        _createData(),
        animate: true,
        behaviors: [],
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 10, color: charts.MaterialPalette.white),
            lineStyle: charts.LineStyleSpec(
                thickness: 0, color: charts.MaterialPalette.gray.shadeDefault),
          ),
        ),
        domainAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 10, color: charts.MaterialPalette.white),
            lineStyle: charts.LineStyleSpec(
                thickness: 0, color: charts.MaterialPalette.gray.shadeDefault),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      children: [
        Spacer(
          flex: 5,
        ),
        RaisedButton(
          textColor: Theme.Colors.primaryColor,
          color: Theme.Colors.goodColor,
          onPressed: () => setState(() => {}),
          child: Text(
            "Water",
            style: Theme.TextStyles.tabTertiary,
          ),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        Spacer(
          flex: 1,
        ),
        RaisedButton(
          textColor: Theme.Colors.primaryColor,
          color: Theme.Colors.goodColor,
          onPressed: () => setState(() => {}),
          child: Text(
            "Steam",
            style: Theme.TextStyles.tabTertiary,
          ),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        Spacer(
          flex: 1,
        ),
        RaisedButton(
          textColor: Theme.Colors.primaryColor,
          color: Theme.Colors.goodColor,
          onPressed: () => setState(() => {}),
          child: Text(
            "Flush",
            style: Theme.TextStyles.tabTertiary,
          ),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        Spacer(
          flex: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.Colors.backgroundColor,
        title:
            Text("Water / Steam / Flush", style: Theme.TextStyles.tabSecondary),
      ),
      body: Container(
        decoration: new BoxDecoration(
          gradient: Theme.Colors.ScreenBackground,
        ),
        child: ListView(
          children: <Widget>[
            _buildGraph(),
            Theme.Helper.horizontalBorder(),
            Center(
              child: _buildControls(),
            ),
            Theme.Helper.horizontalBorder(),
            _buildTemperaturControl(),
            _buildWaterControl(),
            Theme.Helper.horizontalBorder(),
            _buildFlushControl(),
            Theme.Helper.horizontalBorder(),
            _buildSteamConrol(),
            Container(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
