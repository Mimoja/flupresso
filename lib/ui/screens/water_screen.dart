import 'package:flupresso/model/services/ble/machine_service.dart';
import 'package:flupresso/model/services/ble/scale_service.dart';
import 'package:flupresso/service_locator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

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

  List<ShotState> dataPoints = [];

  List<charts.Series<ShotState, double>> _createData(FluTheme theme) {
    return [
      charts.Series<ShotState, double>(
        id: 'Pressure',
        domainFn: (ShotState point, _) => point.sampleTime,
        measureFn: (ShotState point, _) => point.groupPressure,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(theme.backgroundColor),
        strokeWidthPxFn: (_, __) => 3,
        data: dataPoints,
      ),
      charts.Series<ShotState, double>(
        id: 'Flow',
        domainFn: (ShotState point, _) => point.sampleTime,
        measureFn: (ShotState point, _) => point.groupFlow,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(theme.secondaryColor),
        strokeWidthPxFn: (_, __) => 3,
        data: dataPoints,
      ),
    ];
  }

  Widget _buildWaterControl(FluTheme theme) {
    return ButtonBar(
      children: [
        Text(
          'Water:',
          style: theme.tabPrimaryStyle,
        ),
        RaisedButton(
          color: theme.goodColor,
          child: Text(
            '-5',
            style: theme.tabSecondaryStyle,
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
          color: theme.goodColor,
          child: Text(
            '+5',
            style: theme.tabSecondaryStyle,
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

  Widget _buildSteamConrol(FluTheme theme) {
    return ButtonBar(
      children: [
        Text(
          'Steam Timeout: ',
          style: theme.tabPrimaryStyle,
        ),
        RaisedButton(
          color: theme.goodColor,
          child: Text(
            '-1',
            style: theme.tabSecondaryStyle,
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
          color: theme.goodColor,
          child: Text(
            '+1',
            style: theme.tabSecondaryStyle,
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

  Widget _buildTemperaturControl(FluTheme theme) {
    return ButtonBar(
      children: [
        Text(
          'Water Temperature: ',
          style: theme.tabPrimaryStyle,
        ),
        RaisedButton(
          color: theme.goodColor,
          child: Text(
            '-1',
            style: theme.tabSecondaryStyle,
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
          color: theme.goodColor,
          child: Text(
            '+1',
            style: theme.tabSecondaryStyle,
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

  Widget _buildFlushControl(FluTheme theme) {
    return ButtonBar(
      children: [
        Text(
          'Flush Timeout: ',
          style: theme.tabPrimaryStyle,
        ),
        RaisedButton(
          color: theme.goodColor,
          child: Text(
            '-1',
            style: theme.tabSecondaryStyle,
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
          color: theme.goodColor,
          child: Text(
            '+1',
            style: theme.tabSecondaryStyle,
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

  Widget _buildGraph(FluTheme theme) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(left: 10.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: theme.tabColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: charts.LineChart(
        _createData(theme),
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

  Widget _buildControls(FluTheme theme) {
    return Row(
      children: [
        Spacer(
          flex: 5,
        ),
        RaisedButton(
          textColor: theme.primaryColor,
          color: theme.goodColor,
          onPressed: () => setState(() => {}),
          child: Text(
            'Water',
            style: theme.tabTertiaryStyle,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        Spacer(
          flex: 1,
        ),
        RaisedButton(
          textColor: theme.primaryColor,
          color: theme.goodColor,
          onPressed: () => setState(() => {}),
          child: Text(
            'Steam',
            style: theme.tabTertiaryStyle,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        Spacer(
          flex: 1,
        ),
        RaisedButton(
          textColor: theme.primaryColor,
          color: theme.goodColor,
          onPressed: () => setState(() => {}),
          child: Text(
            'Flush',
            style: theme.tabTertiaryStyle,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
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
    var theme = Provider.of<FluTheme>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title:
            Text('Water / Steam / Flush', style: theme.tabSecondaryStyle),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.screenBackgroundGradient,
        ),
        child: ListView(
          children: <Widget>[
            _buildGraph(theme),
            theme.buildHorizontalBorder(),
            Center(
              child: _buildControls(theme),
            ),
            theme.buildHorizontalBorder(),
            _buildTemperaturControl(theme),
            _buildWaterControl(theme),
            theme.buildHorizontalBorder(),
            _buildFlushControl(theme),
            theme.buildHorizontalBorder(),
            _buildSteamConrol(theme),
            Container(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
