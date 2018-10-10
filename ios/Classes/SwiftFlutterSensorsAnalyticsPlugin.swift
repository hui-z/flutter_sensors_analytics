import Flutter
import UIKit
import SensorsAnalyticsSDK

public class SwiftFlutterSensorsAnalyticsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_sensors_analytics_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterSensorsAnalyticsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arg = call.arguments as? [String: Any]
        switch call.method {
        case "start":
            guard let serverURL = arg?["serverURL"] as? String, let debugMode = arg?["debugMode"] as? Int else {
                return
            }
            start(withServerURL: serverURL, andDebugMode: SensorsAnalyticsDebugMode(rawValue: debugMode) ?? .off)
        case "track":
            guard let event = arg?["event"] as? String else {
                return
            }
            let properties = arg?["properties"] as? [String: Any]
            track(event, with: properties)
        case "trackTimerStart":
            guard let event = arg?["event"] as? String else {
                return
            }
            trackTimerStart(event)
        case "trackTimerEnd":
            guard let event = arg?["event"] as? String else {
                return
            }
            let properties = arg?["properties"] as? [String: Any]
            track(event, with: properties)
        case "clearTrackTimer":
            clearTrackTimer()
        case "trackInstallation":
            guard let event = arg?["event"] as? String else {
                return
            }
            let properties = arg?["properties"] as? [String: Any]
            trackInstallation(event, with: properties)
        case "login":
            guard let loginId = arg?["loginId"] as? String else {
                return
            }
            login(loginId: loginId)
        case "logout":
            logout()
        case "trackViewScreen":
            guard let url = arg?["url"] as? String, let properties = arg?["properties"] as? [String: Any] else {
                return
            }
            trackViewScreen(url, and: properties)
        case "setProfiles":
            guard let properties = arg?["properties"] as? [String: Any] else {
                return
            }
            setProfiles(properties)
        case "setOnceProfiles":
            guard let properties = arg?["properties"] as? [String: Any] else {
                return
            }
            setOnceProfiles(properties)
        case "unsetProfile":
            guard let profile = arg?["profile"] as? String else {
                return
            }
            unsetProfile(profile)
        case "increment":
            guard let profile = arg?["profile"] as? String, let amount = arg?["amount"] as? NSNumber else {
                return
            }
            increment(profile: profile, by: amount)
        case "append":
            guard let profile = arg?["profile"] as? String, let content = arg?["content"] as? [String] else {
                return
            }
            append(profile: profile, by: content)
        case "deleteUser":
            deleteUser()
        case "registerSuperProperties":
            guard let properties = arg?["properties"] as? [String: Any] else {
                return
            }
            registerSuperProperties(properties)
        case "unregisterSuperProperty":
            guard let profile = arg?["profile"] as? String else {
                return
            }
            unregisterSuperProperty(profile)
        case "clearSuperProperties":
            clearSuperProperties()
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func start(withServerURL: String, andDebugMode: SensorsAnalyticsDebugMode) {
        SensorsAnalyticsSDK.sharedInstance(withServerURL: withServerURL, andDebugMode: andDebugMode)
    }

    // MARK: - Track相关

    private func track(_ event: String, with properties: [String: Any]?) {
        if !event.isEmpty {
            SensorsAnalyticsSDK.sharedInstance()?.track(event, withProperties: properties)
        }
    }

    /// 记录事件开始时间
    ///
    /// - Parameter event: 事件模型
    private func trackTimerStart(_ event: String) {
        if !event.isEmpty {
            SensorsAnalyticsSDK.sharedInstance()?.trackTimerStart(event)
        }
    }

    /// 记录事件结束时间
    ///
    /// - Parameter event: 事件模型
    private func trackTimerEnd(_ event: String, with properties: [String: Any]) {
        if !event.isEmpty {
            SensorsAnalyticsSDK.sharedInstance()?.trackTimerEnd(event, withProperties: properties)
        }
    }

    /// 清除所有时间计时器
    private func clearTrackTimer() {
        SensorsAnalyticsSDK.sharedInstance()?.clearTrackTimer()
    }

    // 用于在 App 首次启动时追踪渠道来源
    private func trackInstallation(_ event: String, with properties: [String: Any]?) {
        SensorsAnalyticsSDK.sharedInstance()?.trackInstallation(event, withProperties: properties)
    }

    // 关联 DistinctId(匿名 ID)，Sensors Analytics 将匿名 ID与 "config.distinctId" 关联，并认为两个 DistinctId 为同一个用户
    private func login(loginId: String) {
        SensorsAnalyticsSDK.sharedInstance()?.login(loginId)
    }

    // 用户退出，清空注册ID
    private func logout() {
        SensorsAnalyticsSDK.sharedInstance()?.logout()
    }

    // MARK: - Track AppViewScreen

    /// Track $AppViewScreen事件
    ///
    /// - Parameters:
    ///   - url: 当前页面的 url
    ///   - properties: 用户扩展属性
    private func trackViewScreen(_ url: String, and properties: [String: Any]) {
        SensorsAnalyticsSDK.sharedInstance()?.trackViewScreen(url, withProperties: properties)
    }

    /// 设置用户属性
    ///
    /// - Parameter profiles: 用户属性字典
    private func setProfiles(_ profiles: [String: Any]) {
        SensorsAnalyticsSDK.sharedInstance()?.people.set(profiles)
    }

    // MARK: - Profile相关

    /// 只在首次设置时有效的属性
    ///
    /// - Parameter profiles: 用户属性字典
    private func setOnceProfiles(_ profiles: [String: Any]) {
        SensorsAnalyticsSDK.sharedInstance()?.people.setOnce(profiles)
    }

    /// 删除用户属性
    ///
    /// - Parameter profile: 用户属性的key
    private func unsetProfile(_ profile: String) {
        SensorsAnalyticsSDK.sharedInstance()?.people.unset(profile)
    }

    /// 给数值类型的Profile增加数值
    ///
    /// - Parameter numberProfile: numberProfile中，key是<code>NSString</code>，value是<code>NSNumber</code>
    private func increment(profile: String, by amount: NSNumber) {
        SensorsAnalyticsSDK.sharedInstance()?.people.increment(profile, by: amount)
    }

    /// 向一个<code>NSArray</code>类型的value添加一些值
    ///
    /// - Parameters:
    ///   - profile: 属性名称
    ///   - content: 新增的元素
    private func append(profile: String, by content: [String]) {
        SensorsAnalyticsSDK.sharedInstance()?.people.append(profile, by: content as NSArray)
    }

    // 删除当前这个用户的所有记录
    private func deleteUser() {
        SensorsAnalyticsSDK.sharedInstance()?.deleteUser()
    }

    /// 设置事件公共属性，不受DataTrackConfig配置管理
    ///
    /// - Parameter properties: 公共属性字典
    private func registerSuperProperties(_ properties: [String: Any]) {
        SensorsAnalyticsSDK.sharedInstance()?.registerSuperProperties(properties)
    }

    /// 删除一个公共属性
    ///
    /// - Parameter property: 属性的key
    private func unregisterSuperProperty(_ property: String) {
        SensorsAnalyticsSDK.sharedInstance()?.unregisterSuperProperty(property)
    }

    // 删除所有已设置的事件公共属性
    private func clearSuperProperties() {
        SensorsAnalyticsSDK.sharedInstance()?.clearSuperProperties()
    }
}
