package com.zaihui.fluttersensorsanalyticsplugin

import android.content.Context
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.json.JSONObject

class FlutterSensorsAnalyticsPlugin(private val context: Context) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_sensors_analytics_plugin")
            channel.setMethodCallHandler(FlutterSensorsAnalyticsPlugin(registrar.activeContext().applicationContext))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val arg = call.arguments as? HashMap<*, *>
        when (call.method) {
            "start" -> {
                val serverURL = arg?.get("serverURL") as? String ?: return
                val debugMode = arg["debugMode"] as? Int ?: return
                when (debugMode) {
                    0 -> start(context, serverURL, SensorsDataAPI.DebugMode.DEBUG_OFF)
                    1 -> start(context, serverURL, SensorsDataAPI.DebugMode.DEBUG_ONLY)
                    2 -> start(context, serverURL, SensorsDataAPI.DebugMode.DEBUG_AND_TRACK)
                    else -> start(context, serverURL, SensorsDataAPI.DebugMode.DEBUG_OFF)
                }
            }
            "track" -> {
                val event = arg?.get("event") as? String ?: return
                val p = (arg["properties"] as? HashMap<*, *>)
                val properties = if (p == null) null else JSONObject(p)
                track(event, properties)
            }
            "trackTimerStart" -> {
                val event = arg?.get("event") as? String ?: return
                trackTimerStart(event)
            }
            "trackTimerEnd" -> {
                val event = arg?.get("event") as? String ?: return
                val p = (arg["properties"] as? HashMap<*, *>)
                val properties = if (p == null) null else JSONObject(p)
                trackTimerEnd(event, properties)
            }
            "clearTrackTimer" -> trackClearTrackTimer()
            "trackInstallation" -> {
                val event = arg?.get("event") as? String ?: return
                val p = (arg["properties"] as? HashMap<*, *>)
                val properties = if (p == null) null else JSONObject(p)
                trackInstallation(event, properties)
            }
            "login" -> {
                val loginId = arg?.get("loginId") as? String ?: return
                login(loginId)
            }
            "logout" -> logout()
            "trackViewScreen" -> {
                val url = arg?.get("url") as? String ?: return
                val p = (arg["properties"] as? HashMap<*, *>)
                val properties = (if (p == null) null else JSONObject(p)) ?: return
                trackViewScreen(url, properties)
            }
            "setProfiles" -> {
                val p = (arg?.get("properties") as? HashMap<*, *>)
                val properties = (if (p == null) null else JSONObject(p)) ?: return
                profileSet(properties)
            }
            "setOnceProfiles" -> {
                val p = (arg?.get("properties") as? HashMap<*, *>)
                val properties = (if (p == null) null else JSONObject(p)) ?: return
                profileSetOnce(properties)
            }
            "unsetProfile" -> {
                val profile = arg?.get("profile") as? String ?: return
                profileUnset(profile)
            }
            "increment" -> {
                val profile = arg?.get("profile") as? String ?: return
                val amount = arg["amount"] as? Number ?: return
                profileIncrement(profile, amount)
            }
            "append" -> {
                val profile = arg?.get("profile") as? String ?: return
                val content = (arg["content"] as? ArrayList<*>)?.mapNotNull { it as? String }
                        ?: return
                profileAppend(profile, content)
            }
            "deleteProfile" -> {
                profileDelete()
            }
            "registerSuperProperties" -> {
                val p = (arg?.get("properties") as? HashMap<*, *>)
                val properties = (if (p == null) null else JSONObject(p)) ?: return
                registerSuperProperties(properties)
            }
            "unregisterSuperProperty" -> {
                val profile = arg?.get("profile") as? String ?: return
                unregisterSuperProperty(profile)
            }
            "clearSuperProperties" -> clearSuperProperties()
            else -> {
                result.notImplemented()
            }
        }
    }


    private fun start(context: Context, serverURL: String, debugMode: SensorsDataAPI.DebugMode) {
        SensorsDataAPI.sharedInstance(context, serverURL, debugMode)
    }

    /**
     * 自定义埋点
     * 事件属性是一个 JSONObject 对象
     * JSONObject 中每个元素描述一个属性，Key 为属性名称，必需是 String 类型
     * JSONObject 中，每个元素的 Value 是属性的值，支持 String、Number、Boolean、JSONArray 和 Date，
     * 对于 JSONArray，其中所有元素必须是 String 类型
     */
    private fun track(eventName: String, properties: JSONObject?) {
        SensorsDataAPI.sharedInstance()?.track(eventName, properties)
    }

    /**
     * 初始化事件的计时器，计时单位为秒。
     */
    private fun trackTimerStart(eventName: String) {
        SensorsDataAPI.sharedInstance().trackTimerStart(eventName)
    }

    /**
     * 在事件结束时，调用 trackTimerEnd("Event", properties)，SDK 会追踪 "Event" 事件，并自动将事件持续时间记录在事件属性 "event_duration" 中。
     */
    private fun trackTimerEnd(eventName: String, properties: JSONObject?) {
        SensorsDataAPI.sharedInstance()?.trackTimerEnd(eventName, properties)
    }

    /**
     * 清除所有事件计时器
     */
    private fun trackClearTrackTimer() {
        SensorsDataAPI.sharedInstance()?.clearTrackTimer()
    }

    /**
     * 用户注册
     * 当一个用户 注册成功 或 登录成功 之后，可以通过的 login() 方法设置用户的 登录 ID ，并将 匿名 ID 与 登录 ID 进行关联，以保证用户分析的准确性。
     * 对同一个用户，login() 可调用多次，多次调用 login() 时，如果新设置的 登录 ID 与之前缓存的 登录 ID 相同，Sensors Analytics 会忽略该次调用。
     */
    private fun login(loginId: String) {
        SensorsDataAPI.sharedInstance()?.login(loginId)

    }

    private fun logout() {
        SensorsDataAPI.sharedInstance().logout()

    }

    private fun trackInstallation(eventName: String, properties: JSONObject?) {
        SensorsDataAPI.sharedInstance().trackInstallation(eventName, properties)

    }

    private fun trackViewScreen(url: String, properties: JSONObject) {
        SensorsDataAPI.sharedInstance().trackViewScreen(url, properties)

    }

    /**
     * 自定义用户属性
     */
    private fun profileSet(properties: JSONObject) {
        SensorsDataAPI.sharedInstance()?.profileSet(properties)
    }

    /**
     * 记录初次设定的属性
     * 对于只在首次设置时有效的属性，我们可以使用 profileSetOnce() 记录这些属性。
     * 与 profileSet() 方法不同的是，如果被设置的用户属性已存在，则这条记录会被忽略而不会覆盖已有数据，如果属性不存在则会自动创建。
     * 用于为用户设置首次激活时间、首次注册时间等属性。
     */
    private fun profileSetOnce(properties: JSONObject) {
        SensorsDataAPI.sharedInstance().profileSetOnce(properties)
    }

    /**
     * 删除特定的用户属性
     */
    private fun profileUnset(propertyName: String) {
        SensorsDataAPI.sharedInstance()?.profileUnset(propertyName)
    }


    /**
     * 对于数值型的用户属性，可以使用 profileIncrement() 对属性值进行累加。常用于记录用户付费次数、付费额度、积分等属性。
     */
    private fun profileIncrement(property: String, value: Number) {
        SensorsDataAPI.sharedInstance()?.profileIncrement(property, value)
    }

    /**
     * 添加列表类型的属性
     * 列表型属性中的元素必须为 String 类型，且元素的值会自动去重。
     */
    private fun profileAppend(property: String, value: List<String>) {
        SensorsDataAPI.sharedInstance()?.profileAppend(property, value.toSet())
    }


    private fun profileDelete() {
        SensorsDataAPI.sharedInstance().profileDelete()
    }


    /**
     * 注册事件公共属性
     * 重复调用 registerSuperProperties 会覆盖之前已设置的公共属性，公共属性会保存在 App 本地缓存中。
     * 当事件公共属性和事件属性的 Key 冲突时，事件属性优先级最高，它会覆盖事件公共属性。
     */
    private fun registerSuperProperties(properties: JSONObject) {
        SensorsDataAPI.sharedInstance()?.registerSuperProperties(properties)
    }

    /**
     * 删除一个公共属性
     */
    private fun unregisterSuperProperty(superPropertyName: String) {
        SensorsDataAPI.sharedInstance()?.unregisterSuperProperty(superPropertyName)
    }

    /**
     * 删除所有已设置的事件公共属性
     */
    private fun clearSuperProperties() {
        SensorsDataAPI.sharedInstance()?.clearSuperProperties()
    }

}
