import 'dart:developer';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flupresso/model/services/ble/coffeeService.dart';
import 'package:flupresso/model/services/ble/scaleService.dart';
import 'package:flupresso/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flupresso/ui/Theme.dart' as Theme;
import 'package:flupresso/ui/tab.dart';

class Graph with TabEntry {
  @override
  Widget getTabContent() {
    return GraphTab();
  }

  @override
  Widget getImage() {
    return Center(
      child: new Icon(
        Icons.trending_up,
        size: 55.0,
        color: Theme.Colors.primaryColor,
      ),
    );
  }
}

class ShotInsightPoint {
  final double seconds;
  final double pressure;
  final double flow;

  ShotInsightPoint(this.seconds, this.pressure, this.flow);
}

class GraphTab extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<GraphTab> {
  ScaleService scale;
  CoffeeService coffeeService;

  _GraphState() {
    scale = getIt<ScaleService>();
    coffeeService = getIt<CoffeeService>();
  }

  @override
  initState() {
    coffeeService.addListener(updateCoffee);
    super.initState();
  }

  updateCoffee() => setState(() {
        ShotState shot = coffeeService.state.shot;
        if (coffeeService.state.coffeeState == CoffeeState.idle) {
          inShot = false;
          return;
        }
        if (!inShot) {
          inShot = true;
          dataPoints.clear();
          baseTime = shot.sampleTime;
        }

        dataPoints.add(ShotInsightPoint(
            shot.sampleTime - baseTime, shot.groupPressure, shot.groupFlow));
      });

  bool inShot = false;
  List<ShotInsightPoint> dataPoints = List();
  double baseTime;

  List<charts.Series<ShotInsightPoint, double>> _createData() {
    return [
      new charts.Series<ShotInsightPoint, double>(
        id: 'Pressure',
        domainFn: (ShotInsightPoint point, _) => point.seconds,
        measureFn: (ShotInsightPoint point, _) => point.pressure,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Theme.Colors.tabBackground),
        strokeWidthPxFn: (_, __) => 3,
        data: dataPoints,
      ),
      new charts.Series<ShotInsightPoint, double>(
        id: 'Flow',
        domainFn: (ShotInsightPoint point, _) => point.seconds,
        measureFn: (ShotInsightPoint point, _) => point.flow,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Theme.Colors.secondaryColor),
        strokeWidthPxFn: (_, __) => 3,
        data: dataPoints,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //TODO test for scale conneciton
    Widget insights;
    if (coffeeService.state.shot != null) {
      insights = Column(
        children: [
          Row(
            children: [
              Text("State: ", style: Theme.TextStyles.tabSecondary),
              Text(
                  coffeeService.state.coffeeState
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
                  coffeeService.state.shot.groupPressure.toStringAsFixed(1) +
                      " bar",
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
          Row(
            children: [
              Text("Flow: ", style: Theme.TextStyles.tabSecondary),
              Text(
                  coffeeService.state.shot.groupFlow.toStringAsFixed(2) +
                      " ml/s",
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
          Row(
            children: [
              Text("Mix Temp: ", style: Theme.TextStyles.tabSecondary),
              Text(coffeeService.state.shot.mixTemp.toStringAsFixed(2) + " °C",
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
          Row(
            children: [
              Text("Head Temp: ", style: Theme.TextStyles.tabSecondary),
              Text(coffeeService.state.shot.headTemp.toStringAsFixed(2) + " °C",
                  style: Theme.TextStyles.tabPrimary),
            ],
          ),
        ],
      );
    } else {
      insights =
          Text("Machine is not connected", style: Theme.TextStyles.tabPrimary);
    }
    /*
      new Row(
                  children: <Widget>[
                    new Icon(Icons.hourglass_empty,
                        size: 14.0, color: Theme.Colors.primaryColor),
                    new Text("15 sec", style: Theme.TextStyles.tabTertiary),
                    new Container(width: 24.0),
                    new Icon(Icons.location_on,
                        size: 14.0, color: Theme.Colors.secondaryColor),
                    new Text("93.6°C", style: Theme.TextStyles.tabTertiary),
                  ],
                ),
    */

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 95.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                insights,
                StreamBuilder<WeightMeassurement>(
                    stream: scale.stream,
                    initialData: WeightMeassurement(0, 0),
                    builder: (BuildContext context,
                        AsyncSnapshot<WeightMeassurement> snapshot) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Text("Weight: ",
                                  style: Theme.TextStyles.tabSecondary),
                              Text(
                                  snapshot.data.weight.toStringAsFixed(2) + "g",
                                  style: Theme.TextStyles.tabSecondary),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Flow:     ",
                                  style: Theme.TextStyles.tabSecondary),
                              Text(
                                  snapshot.data.flow.toStringAsFixed(2) + "g/s",
                                  style: Theme.TextStyles.tabSecondary)
                            ],
                          ),
                        ],
                      );
                    }),
                new Container(
                    color: Theme.Colors.tabHighlightColor,
                    width: 24.0,
                    height: 1.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0)),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            height: 300,
            margin: const EdgeInsets.only(left: 10.0),
            width: MediaQuery.of(context).size.width - 105,
            decoration: new BoxDecoration(
              color: Theme.Colors.primaryColor,
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
            ),
          ),
          Container(
            height: 10,
          ),
        ],
      ),
    );
  }
}
