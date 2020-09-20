import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flupresso/model/services/ble/machine_service.dart';
import 'package:flupresso/model/services/ble/scale_service.dart';
import 'package:flupresso/model/services/state/coffee_service.dart';
import 'package:flupresso/model/services/state/profile_service.dart';
import 'package:flupresso/service_locator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flupresso/ui/screens/coffee_selection.dart';
import 'package:flupresso/ui/screens/machine_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class CoffeeScreen extends StatefulWidget {
  @override
  _CoffeeScreenState createState() => _CoffeeScreenState();
}

class _CoffeeScreenState extends State<CoffeeScreen> {
  CoffeeService coffeeSelectionService;
  EspressoMachineService machineService;
  ProfileService profileService;
  ScaleService scaleService;

  @override
  void initState() {
    super.initState();
    machineService = getIt<EspressoMachineService>();
    machineService.addListener(() {
      setState(() {});
    });
    profileService = getIt<ProfileService>();
    profileService.addListener(() {
      setState(() {});
    });

    coffeeSelectionService = getIt<CoffeeService>();
    coffeeSelectionService.addListener(() {
      setState(() {});
    });
    // Scale services is consumed as stream
    scaleService = getIt<ScaleService>();
  }

  void updateCoffee() => setState(() {
        var shot = machineService.state.shot;
        if (machineService.state.coffeeState == EspressoMachineState.idle) {
          inShot = false;
          return;
        }
        if (!inShot) {
          inShot = true;
          dataPoints.clear();
          baseTime = shot.sampleTime;
        }

        shot.sampleTime = shot.sampleTime - baseTime;
        dataPoints.add(shot);
      });

  bool inShot = false;
  List<ShotState> dataPoints = [];
  double baseTime;

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

  Widget _buildGraph(FluTheme theme) {
    return Container(
      height: 300,
      margin: const EdgeInsets.only(left: 10.0),
      width: MediaQuery.of(context).size.width - 105,
      decoration: BoxDecoration(
        color: theme.tabColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: charts.LineChart(
        _createData(theme),
        animate: true,
        behaviors: [
          // Define one domain and two measure annotations configured to render
          // labels in the chart margins.
          charts.RangeAnnotation([
            charts.RangeAnnotationSegment(
                9.5, 12, charts.RangeAnnotationAxisType.measure,
                labelAnchor: charts.AnnotationLabelAnchor.end,
                color: const charts.Color(r: 0xff, g: 0, b: 0, a: 0x30),
                labelDirection: charts.AnnotationLabelDirection.vertical),
          ], defaultLabelPosition: charts.AnnotationLabelPosition.margin),
        ],
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 10,
                color:
                    charts.ColorUtil.fromDartColor(theme.primaryColor)),
            lineStyle: charts.LineStyleSpec(
                thickness: 0,
                color:
                    charts.ColorUtil.fromDartColor(theme.primaryColor)),
          ),
        ),
        domainAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 10,
                color:
                    charts.ColorUtil.fromDartColor(theme.primaryColor)),
            lineStyle: charts.LineStyleSpec(
                thickness: 0,
                color:
                    charts.ColorUtil.fromDartColor(theme.primaryColor)),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveInsights(FluTheme theme) {
    Widget insights;
    if (machineService.state.shot != null) {
      insights = Column(
        children: [
          Row(
            children: [
              Text('State: ', style: theme.tabSecondaryStyle),
              Text(
                  machineService.state.coffeeState
                      .toString()
                      .substring(12)
                      .toUpperCase(),
                  style: theme.tabPrimaryStyle),
            ],
          ),
          Row(
            children: [
              Text('Pressure: ', style: theme.tabSecondaryStyle),
              Text(
                  machineService.state.shot.groupPressure.toStringAsFixed(1) +
                      ' bar',
                  style: theme.tabPrimaryStyle),
            ],
          ),
          Row(
            children: [
              Text('Flow: ', style: theme.tabSecondaryStyle),
              Text(
                  machineService.state.shot.groupFlow.toStringAsFixed(2) +
                      ' ml/s',
                  style: theme.tabPrimaryStyle),
            ],
          ),
          Row(
            children: [
              Text('Mix Temp: ', style: theme.tabSecondaryStyle),
              Text(machineService.state.shot.mixTemp.toStringAsFixed(2) + ' °C',
                  style: theme.tabPrimaryStyle),
            ],
          ),
          Row(
            children: [
              Text('Head Temp: ', style: theme.tabSecondaryStyle),
              Text(
                  machineService.state.shot.headTemp.toStringAsFixed(2) + ' °C',
                  style: theme.tabPrimaryStyle),
            ],
          ),
        ],
      );
    } else {
      insights =
          Text('Machine is not connected', style: theme.tabPrimaryStyle);
    }
    return insights;
  }

  Row _buildScaleInsight(FluTheme theme) {
    return Row(
      children: [
        Spacer(),
        StreamBuilder<WeightMeassurement>(
          stream: scaleService.stream,
          initialData: WeightMeassurement(0, 0),
          builder: (BuildContext context,
              AsyncSnapshot<WeightMeassurement> snapshot) {
            return Column(
              children: <Widget>[
                Row(
                  children: [
                    Text('Weight: ', style: theme.tabSecondaryStyle),
                    Text(snapshot.data.weight.toStringAsFixed(2) + 'g',
                        style: theme.tabSecondaryStyle),
                  ],
                ),
                Row(
                  children: [
                    Text('Flow: ', style: theme.tabSecondaryStyle),
                    Text(snapshot.data.flow.toStringAsFixed(2) + 'g/s',
                        style: theme.tabSecondaryStyle)
                  ],
                ),
              ],
            );
          },
        ),
        Spacer(),
      ],
    );
  }

  var pressAttention = true;

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<FluTheme>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.backgroundColor,
          title: Row(
            children: [
              Text('Coffee', style: theme.tabSecondaryStyle),
              Container(
                width: 30,
              ),
              Flexible(
                child: RaisedButton(
                  textColor: theme.primaryColor,
                  color: pressAttention
                      ? theme.goodColor
                      : theme.badColor,
                  onPressed: () =>
                      setState(() => pressAttention = !pressAttention),
                  child: pressAttention ? Text('Start') : Text('Stop'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: theme.tabColor,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            tabs: [
              Tab(
                child: Text(
                  'Live',
                  style: theme.tabLabelStyle,
                ),
              ),
              Tab(
                child: Text(
                  'Settings',
                  style: theme.tabLabelStyle,
                ),
              ),
              Tab(
                child: Text(
                  'History',
                  style: theme.tabLabelStyle,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: theme.screenBackgroundGradient,
              ),
              child: Column(
                children: <Widget>[
                  _buildLiveInsights(theme),
                  theme.buildHorizontalBorder(),
                  _buildScaleInsight(theme),
                  _buildGraph(theme),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: theme.screenBackgroundGradient,
              ),
              child: CoffeeSelectionTab(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: theme.screenBackgroundGradient,
              ),
              child: MachineSelectionTab(),
            ),
          ],
        ),
      ),
    );
  }
}
