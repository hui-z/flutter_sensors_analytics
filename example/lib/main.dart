import 'package:flutter/material.dart';
import 'package:flutter_sensors_analytics_plugin/flutter_sensors_analytics_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterSensorsAnalyticsPlugin.start("https://sensor-collect.kezaihui.com/sa?project=default", 2);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: RawMaterialButton(
              child: Text('tap'),
              onPressed: () {
                FlutterSensorsAnalyticsPlugin.track(
                    'flutter_sensors_analytics_test_event');
              }),
        ),
      ),
    );
  }
}
