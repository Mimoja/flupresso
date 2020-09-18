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
import 'package:flupresso/ui/theme.dart' as Theme;

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

  updateCoffee() => setState(() {
        ShotState shot = machineService.state.shot;
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
  List<ShotState> dataPoints = List();
  double baseTime;

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

  Widget _buildGraph() {
    return Container(
      height: 300,
      margin: const EdgeInsets.only(left: 10.0),
      width: MediaQuery.of(context).size.width - 105,
      decoration: new BoxDecoration(
        color: Theme.Colors.tabColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
      ),
      child: charts.LineChart(
        _createData(),
        animate: true,
        behaviors: [
          // Define one domain and two measure annotations configured to render
          // labels in the chart margins.
          new charts.RangeAnnotation([
            new charts.RangeAnnotationSegment(
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
                    charts.ColorUtil.fromDartColor(Theme.Colors.primaryColor)),
            lineStyle: charts.LineStyleSpec(
                thickness: 0,
                color:
                    charts.ColorUtil.fromDartColor(Theme.Colors.primaryColor)),
          ),
        ),
        domainAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 10,
                color:
                    charts.ColorUtil.fromDartColor(Theme.Colors.primaryColor)),
            lineStyle: charts.LineStyleSpec(
                thickness: 0,
                color:
                    charts.ColorUtil.fromDartColor(Theme.Colors.primaryColor)),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveInsights() {
    Widget insights;
    if (machineService.state.shot != null) {
      insights = Column(
        children: [
          Row(
            children: [
              Text("State: ", style: Theme.TextStyles.tabSecondary),
              Text(
                  machineService.state.coffeeState
                      .toString()
                      .substring(12)
                      .toUpperCase(),
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
          Row(
            children: [
              Text("Pressure: ", style: Theme.TextStyles.tabSecondary),
              Text(
                  machineService.state.shot.groupPressure.toStringAsFixed(1) +
                      " bar",
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
          Row(
            children: [
              Text("Flow: ", style: Theme.TextStyles.tabSecondary),
              Text(
                  machineService.state.shot.groupFlow.toStringAsFixed(2) +
                      " ml/s",
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
          Row(
            children: [
              Text("Mix Temp: ", style: Theme.TextStyles.tabSecondary),
              Text(machineService.state.shot.mixTemp.toStringAsFixed(2) + " °C",
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
          Row(
            children: [
              Text("Head Temp: ", style: Theme.TextStyles.tabSecondary),
              Text(
                  machineService.state.shot.headTemp.toStringAsFixed(2) + " °C",
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
        ],
      );
    } else {
      insights =
          Text("Machine is not connected", style: Theme.TextStyles.tabPrimary);
    }
    return insights;
  }

  _buildScaleInsight() {
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
                    Text("Weight: ", style: Theme.TextStyles.tabSecondary),
                    Text(snapshot.data.weight.toStringAsFixed(2) + "g",
                        style: Theme.TextStyles.tabSecondary),
                  ],
                ),
                Row(
                  children: [
                    Text("Flow: ", style: Theme.TextStyles.tabSecondary),
                    Text(snapshot.data.flow.toStringAsFixed(2) + "g/s",
                        style: Theme.TextStyles.tabSecondary)
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.Colors.backgroundColor,
          title: Row(
            children: [
              Text("Coffee", style: Theme.TextStyles.tabSecondary),
              Container(
                width: 30,
              ),
              Flexible(
                child: RaisedButton(
                  textColor: Theme.Colors.primaryColor,
                  color: pressAttention
                      ? Theme.Colors.goodColor
                      : Theme.Colors.badColor,
                  onPressed: () =>
                      setState(() => pressAttention = !pressAttention),
                  child: pressAttention ? Text("Start") : Text("Stop"),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: new BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Theme.Colors.tabColor,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            tabs: [
              Tab(
                child: Text(
                  "Live",
                  style: Theme.TextStyles.tabLabel,
                ),
              ),
              Tab(
                child: Text(
                  "Settings",
                  style: Theme.TextStyles.tabLabel,
                ),
              ),
              Tab(
                child: Text(
                  "History",
                  style: Theme.TextStyles.tabLabel,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              decoration: new BoxDecoration(
                gradient: Theme.Colors.ScreenBackground,
              ),
              child: Column(
                children: <Widget>[
                  _buildLiveInsights(),
                  Theme.Helper.horizontalBorder(),
                  _buildScaleInsight(),
                  _buildGraph(),
                ],
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                gradient: Theme.Colors.ScreenBackground,
              ),
              child: CoffeeSelectionTab(),
            ),
            Container(
              decoration: new BoxDecoration(
                gradient: Theme.Colors.ScreenBackground,
              ),
              child: MachineSelectionTab(),
            ),
          ],
        ),
      ),
    );
  }
}
