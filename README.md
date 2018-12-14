# flutter_sensors_analytics_plugin

[![pub packages](https://img.shields.io/pub/v/flutter_sensors_analytics_plugin.svg)](https://pub.dartlang.org/packages/flutter_sensors_analytics_plugin)
[![LICENSE](https://img.shields.io/github/license/hui-z/flutter_sensors_analytics.svg)](https://github.com/hui-z/flutter_sensors_analytics/blob/master/LICENSE)

这是一个集成神策SDK的插件

使用前请先了解神策分析 [Android SDK使用说明](https://www.sensorsdata.cn/manual/android_sdk.html), [iOS SDK使用说明](https://www.sensorsdata.cn/manual/ios_sdk.html)

由于神策SDK依赖`com.android.applicatio`需要手动在Android项目中添加依赖

1. 在 project 级别的 build.gradle 文件中添加 Sensors Analytics android-gradle-plugin 依赖：

    ```
    //添加神策分析 android-gradle-plugin 依赖
    classpath 'com.sensorsdata.analytics.android:android-gradle-plugin2:2.1.0'
    ```

2. 在 主 module 的 build.gradle 文件中添加 com.sensorsdata.analytics.android 插件：

    ```
    //添加 com.sensorsdata.analytics.android 插件
    apply plugin: 'com.sensorsdata.analytics.android'
    ```

3. 由于 SDK 会依赖 appcompat-v7 需要添加下面依赖( 如果项目中已引入了 v7包，可以不添加 )：

    ```
    implementation "com.android.support:appcompat-v7:$rootProject.supportLibraryVersion"
    ```

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).
