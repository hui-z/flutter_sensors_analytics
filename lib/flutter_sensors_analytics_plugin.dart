import 'dart:async';

import 'package:flutter/services.dart';

/// Debug模式有三种选项:
/// * [off] 关闭DEBUG模式
/// * [only] 打开DEBUG模式，但该模式下发送的数据仅用于调试，不进行数据导入
/// * [andTrack] 打开DEBUG模式，并将数据导入到SensorsAnalytics中
enum DebugMode { off, only, andTrack }

class FlutterSensorsAnalyticsPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_sensors_analytics_plugin');

  /// 根据传入的配置, 初始化SDK
  static Future start(String serverURL, DebugMode debugMode) async {
    return await _channel.invokeMethod(
        'start', {'serverURL': serverURL, 'debugMode': debugMode.index});
  }

  /// 调用track接口, 追踪一个带有属性的event
  static Future track(String event, {Map<String, dynamic> properties}) async {
    _propertiesRemoveNull(properties);
    return await _channel
        .invokeMethod('track', {'event': event, 'properties': properties});
  }

  /// 记录事件开始时间, 该方法并不会真正发送事件, 在事件结束时调用 [trackTimerEnd]
  static Future trackTimerStart(String event) async {
    return await _channel.invokeMethod('trackTimerStart');
  }

  /// 在事件结束时调用SDK,会追踪 "Event" 事件,并自动将事件持续时间记录在事件属性 "event_duration" 中。
  static Future trackTimerEnd(String event,
      {Map<String, dynamic> properties}) async {
    _propertiesRemoveNull(properties);
    return await _channel.invokeMethod(
        'trackTimerEnd', {'event': event, 'properties': properties});
  }

  /// 清除所有事件计时器
  static Future clearTrackTimer() async {
    return await _channel.invokeMethod('clearTrackTimer');
  }

  /// 用于在 App 首次启动时追踪渠道来源
  static Future trackInstallation(String event) async {
    return await _channel.invokeMethod('trackInstallation', {'event': event});
  }

  ///  关联 DistinctId(匿名 ID),Sensors Analytics 将匿名 ID与 "config.distinctId" 关联,并认为两个 DistinctId 为同一个用户
  static Future login(String loginId) async {
    return await _channel.invokeMethod('login', {'loginId': loginId});
  }

  /// 用户退出,清空注册ID
  static Future logout() async {
    return await _channel.invokeMethod('logout');
  }

  /// Track $AppViewScreen事件
  static Future trackViewScreen(
      String event, Map<String, dynamic> properties) async {
    _propertiesRemoveNull(properties);
    return await _channel.invokeMethod(
        'trackViewScreen', {'event': event, 'properties': properties});
  }

  /// 设置用户属性
  static Future setProfiles(Map<String, dynamic> properties) async {
    _propertiesRemoveNull(properties);
    return await _channel
        .invokeMethod('setProfiles', {'properties': properties});
  }

  /// 只在首次设置时有效的属性
  static Future setOnceProfiles(Map<String, dynamic> properties) async {
    _propertiesRemoveNull(properties);
    return await _channel
        .invokeMethod('setOnceProfiles', {'properties': properties});
  }

  /// 删除用户属性
  static Future unsetProfile(String profile) async {
    return await _channel.invokeMethod('unsetProfile', {'profile': profile});
  }

  /// 给一个数值类型的Profile增加一个数值
  static Future increment(String profile, num amount) async {
    return await _channel
        .invokeMethod('increment', {'profile': profile, 'amount': amount});
  }

  /// 向一个NSSet或者NSArray类型的value添加一些值
  /// 这个NSSet或者NSArray的元素必须是NSString,否则,会忽略 同时,如果要append的Profile之前不存在,会初始化一个空的NSSet或者NSArray
  static Future append(List<String> content) async {
    return await _channel.invokeMethod('append', {'content': content});
  }

  /// (iOS)删除当前这个用户的所有记录
  static Future deleteUser() async {
    return await _channel.invokeMethod('deleteUser');
  }

  /// (Android) 删除用户所有Profile
  static Future deleteProfile() async {
    return await _channel.invokeMethod('deleteProfile');
  }

  /// 设置事件公共属性，不受DataTrackConfig配置管理
  static Future registerSuperProperties(Map<String, dynamic> properties) async {
    _propertiesRemoveNull(properties);
    return await _channel
        .invokeMethod('registerSuperProperties', {'properties': properties});
  }

  /// 删除一个公共属性
  static Future unregisterSuperProperty(String property) async {
    return await _channel
        .invokeMethod('unregisterSuperProperty', {'property': property});
  }

  /// 删除所有已设置的事件公共属性
  static Future clearSuperProperties() async {
    return await _channel.invokeMethod('clearSuperProperties');
  }

  static void _propertiesRemoveNull(Map<String, dynamic> properties) {
    properties.removeWhere((_, value) => value == null);
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
