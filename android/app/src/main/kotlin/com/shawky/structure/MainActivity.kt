package com.shawky.structure

import android.app.ActivityManager
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.BatteryManager
import android.os.Build
import android.os.StatFs
import android.util.DisplayMetrics
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val channelName = "com.shawky.structure/device_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "getDeviceData") {
                    result.success(collectDeviceData())
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun collectDeviceData(): Map<String, Any?> {
        val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
        val batteryStatus = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val batteryState = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        val activityManager = getSystemService(ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo().also(activityManager::getMemoryInfo)
        val storage = StatFs(filesDir.absolutePath)
        val configuration = resources.configuration
        val metrics: DisplayMetrics = resources.displayMetrics

        return linkedMapOf(
            "Hardware" to linkedMapOf(
                "manufacturer" to Build.MANUFACTURER,
                "brand" to Build.BRAND,
                "model" to Build.MODEL,
                "device" to Build.DEVICE,
                "product" to Build.PRODUCT,
                "board" to Build.BOARD,
                "hardware" to Build.HARDWARE,
                "bootloader" to Build.BOOTLOADER,
                "supportedAbis" to Build.SUPPORTED_ABIS.toList(),
                "cpuCores" to Runtime.getRuntime().availableProcessors(),
                "isPhysicalDevice" to !isEmulator(),
            ),
            "Operating system" to linkedMapOf(
                "name" to "Android",
                "release" to Build.VERSION.RELEASE,
                "sdkInt" to Build.VERSION.SDK_INT,
                "codename" to Build.VERSION.CODENAME,
                "securityPatch" to Build.VERSION.SECURITY_PATCH,
                "buildId" to Build.ID,
                "displayBuild" to Build.DISPLAY,
                "fingerprint" to Build.FINGERPRINT,
                "buildType" to Build.TYPE,
                "tags" to Build.TAGS,
            ),
            "Resources" to linkedMapOf(
                "totalMemoryBytes" to memoryInfo.totalMem,
                "availableMemoryBytes" to memoryInfo.availMem,
                "lowMemory" to memoryInfo.lowMemory,
                "totalStorageBytes" to storage.totalBytes,
                "availableStorageBytes" to storage.availableBytes,
            ),
            "Battery" to linkedMapOf(
                "levelPercent" to batteryManager
                    .getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY),
                "isCharging" to (
                    batteryState == BatteryManager.BATTERY_STATUS_CHARGING ||
                        batteryState == BatteryManager.BATTERY_STATUS_FULL
                    ),
            ),
            "Display (native)" to linkedMapOf(
                "densityDpi" to metrics.densityDpi,
                "density" to metrics.density,
                "fontScale" to configuration.fontScale,
            ),
            "Regional settings" to linkedMapOf(
                "language" to Locale.getDefault().language,
                "locale" to Locale.getDefault().toLanguageTag(),
                "timeZone" to java.util.TimeZone.getDefault().id,
                "is24HourFormat" to android.text.format.DateFormat.is24HourFormat(this),
            ),
            "Network" to networkData(),
        )
    }

    private fun networkData(): Map<String, Any?> {
        val manager = getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            @Suppress("DEPRECATION")
            val info = manager.activeNetworkInfo
            return linkedMapOf(
                "connected" to (info?.isConnected == true),
                "transport" to (info?.typeName?.lowercase(Locale.US) ?: "none"),
                "metered" to manager.isActiveNetworkMetered,
            )
        }
        val network = manager.activeNetwork
        val capabilities = network?.let(manager::getNetworkCapabilities)
        val transport = when {
            capabilities == null -> "none"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "cellular"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> "ethernet"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN) -> "vpn"
            else -> "other"
        }
        return linkedMapOf(
            "connected" to (capabilities != null),
            "transport" to transport,
            "metered" to manager.isActiveNetworkMetered,
            "internetCapability" to (capabilities?.hasCapability(
                NetworkCapabilities.NET_CAPABILITY_INTERNET,
            ) ?: false),
            "validated" to (capabilities?.hasCapability(
                NetworkCapabilities.NET_CAPABILITY_VALIDATED,
            ) ?: false),
        )
    }

    private fun isEmulator(): Boolean =
        Build.FINGERPRINT.startsWith("generic") ||
            Build.FINGERPRINT.lowercase(Locale.US).contains("emulator") ||
            Build.MODEL.contains("google_sdk") ||
            Build.MODEL.lowercase(Locale.US).contains("emulator") ||
            Build.MODEL.contains("Android SDK built for x86") ||
            Build.MANUFACTURER.contains("Genymotion") ||
            (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) ||
            Build.PRODUCT == "google_sdk"
}
