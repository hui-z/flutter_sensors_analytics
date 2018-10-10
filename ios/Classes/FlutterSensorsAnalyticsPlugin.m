#import "FlutterSensorsAnalyticsPlugin.h"
#import <flutter_sensors_analytics_plugin/flutter_sensors_analytics_plugin-Swift.h>

@implementation FlutterSensorsAnalyticsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSensorsAnalyticsPlugin registerWithRegistrar:registrar];
}
@end
