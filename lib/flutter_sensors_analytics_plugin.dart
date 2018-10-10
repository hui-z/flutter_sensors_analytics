import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSensorsAnalyticsPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_sensors_analytics_plugin');


  /// 0:DEBUG_OFF
  /// 1:DEBUG_ONLY
  /// 2:DEBUG_AND_TRACK
  /// other:DEBUG_OFF
  static Future start(String serverURL, int debugMode) async {
    return await _channel.invokeMethod(
        'start', {'serverURL': serverURL, 'debugMode': debugMode});
  }

  static Future track(String event, {Map<String, dynamic> properties}) async {
    return await _channel
        .invokeMethod('track', {'event': event, 'properties': properties});
  }

  static Future trackTimerStart(String event) async {
    return await _channel.invokeMethod('trackTimerStart');
  }

  static Future trackTimerEnd(String event,
      {Map<String, dynamic> properties}) async {
    return await _channel.invokeMethod(
        'trackTimerEnd', {'event': event, 'properties': properties});
  }

  static Future clearTrackTimer() async {
    return await _channel.invokeMethod('clearTrackTimer');
  }

  static Future trackInstallation(String event) async {
    return await _channel.invokeMethod('trackInstallation', {'event': event});
  }

  static Future login(String loginId) async {
    return await _channel.invokeMethod('login', {'loginId': loginId});
  }

  static Future logout() async {
    return await _channel.invokeMethod('logout');
  }

  static Future trackViewScreen(
      String event, Map<String, dynamic> properties) async {
    return await _channel.invokeMethod(
        'trackViewScreen', {'event': event, 'properties': properties});
  }

  static Future setProfiles(Map<String, dynamic> properties) async {
    return await _channel
        .invokeMethod('setProfiles', {'properties': properties});
  }

  static Future setOnceProfiles(Map<String, dynamic> properties) async {
    return await _channel
        .invokeMethod('setOnceProfiles', {'properties': properties});
  }

  static Future unsetProfile(String profile) async {
    return await _channel.invokeMethod('unsetProfile', {'profile': profile});
  }

  static Future increment(String profile, num amount) async {
    return await _channel
        .invokeMethod('increment', {'profile': profile, 'amount': amount});
  }

  static Future append(List<String> content) async {
    return await _channel.invokeMethod('append', {'content': content});
  }

  /*iOS*/
  static Future deleteUser() async {
    return await _channel.invokeMethod('deleteUser');
  }

  /*Android*/
  static Future deleteProfile() async {
    return await _channel.invokeMethod('deleteProfile');
  }

  static Future registerSuperProperties(Map<String, dynamic> properties) async {
    return await _channel
        .invokeMethod('registerSuperProperties', {'properties': properties});
  }

  static Future unregisterSuperProperty(String property) async {
    return await _channel
        .invokeMethod('unregisterSuperProperty', {'property': property});
  }

  static Future clearSuperProperties() async {
    return await _channel.invokeMethod('clearSuperProperties');
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
