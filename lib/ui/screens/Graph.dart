import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:startup_namer/ui/Theme.dart' as Theme;
import 'package:startup_namer/ui/tab.dart';

class ShotInsightPoint {
  final double seconds;
  final double pressure;
  final double flow;

  ShotInsightPoint(this.seconds, this.pressure, this.flow);
}

class Graph extends StatelessWidget with TabEntry {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }

  @override
  Widget getScreen(BuildContext context) {
    return this;
  }

  static List<charts.Series<ShotInsightPoint, double>> _createSampleData() {
    final data = [
      new ShotInsightPoint(0.04, 0.04, 0.1),
      new ShotInsightPoint(0.197, 0.02, 0.3),
      new ShotInsightPoint(0.243, 0.03, 1.2),
      new ShotInsightPoint(0.443, 0.02, 2.2),
      new ShotInsightPoint(0.643, 0.03, 3.2),
      new ShotInsightPoint(0.843, 0.02, 4.01),
      new ShotInsightPoint(1.043, 0.04, 4.05),
      new ShotInsightPoint(1.243, 0.02, 4.01),
      new ShotInsightPoint(1.543, 0.03, 3.99),
      new ShotInsightPoint(2.543, 0.1, 4.05),
      new ShotInsightPoint(3.543, 0.22, 3.99),
      new ShotInsightPoint(4.543, 1.02, 3.85),
      new ShotInsightPoint(5.543, 3.02, 1.6),
      new ShotInsightPoint(6.543, 5.02, 1.5),
      new ShotInsightPoint(7.543, 8.02, 1.5),
      new ShotInsightPoint(8.543, 8.702, 1.5),
      new ShotInsightPoint(9.543, 8.82, 1.6),
      new ShotInsightPoint(10.543, 9.02, 1.6),
      new ShotInsightPoint(11.543, 9.12, 1.7),
      new ShotInsightPoint(12.543, 8.82, 1.8),
      new ShotInsightPoint(13.543, 8.52, 1.9),
      new ShotInsightPoint(14.543, 8.45, 2.0),
      new ShotInsightPoint(15.55, 8.2, 2.1),
    ];

    return [
      new charts.Series<ShotInsightPoint, double>(
        id: 'Pressure',
        domainFn: (ShotInsightPoint point, _) => point.seconds,
        measureFn: (ShotInsightPoint point, _) => point.pressure,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Theme.Colors.tabBackground),
        strokeWidthPxFn: (_, __) => 3,
        data: data,
      ),
      new charts.Series<ShotInsightPoint, double>(
        id: 'Flow',
        domainFn: (ShotInsightPoint point, _) => point.seconds,
        measureFn: (ShotInsightPoint point, _) => point.flow,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Theme.Colors.secondaryColor),
        strokeWidthPxFn: (_, __) => 3,
        data: data,
      ),
    ];
  }

  @override
  Widget getTabContent(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 95.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("8.2 bars", style: Theme.TextStyles.tabPrimary),
                new Text("2.1 ml / s", style: Theme.TextStyles.tabSecondary),
                new Container(
                    color: Theme.Colors.tabHighlightColor,
                    width: 24.0,
                    height: 1.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0)),
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
              _createSampleData(),
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

  @override
  Widget getImage(BuildContext context) {
    return Center(
      child: new Icon(
        Icons.trending_up,
        size: 55.0,
        color: Theme.Colors.primaryColor,
      ),
    );
  }
}
