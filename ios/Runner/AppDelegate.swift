import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "com.shawky.structure/device_info"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "getDeviceData" else {
        result(FlutterMethodNotImplemented)
        return
      }
      result(self?.collectDeviceData() ?? [:])
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func collectDeviceData() -> [String: Any] {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    let process = ProcessInfo.processInfo
    let fileAttributes = try? FileManager.default.attributesOfFileSystem(
      forPath: NSHomeDirectory()
    )
    return [
      "Hardware": [
        "name": device.name,
        "model": device.model,
        "localizedModel": device.localizedModel,
        "machineIdentifier": machineIdentifier(),
        "cpuCores": process.processorCount,
        "activeCpuCores": process.activeProcessorCount,
        "isPhysicalDevice": !isSimulator,
      ],
      "Operating system": [
        "name": device.systemName,
        "version": device.systemVersion,
        "kernel": process.operatingSystemVersionString,
      ],
      "Resources": [
        "physicalMemoryBytes": process.physicalMemory,
        "totalStorageBytes": fileAttributes?[.systemSize] as? NSNumber ?? 0,
        "availableStorageBytes": fileAttributes?[.systemFreeSize] as? NSNumber ?? 0,
        "thermalState": thermalStateName(process.thermalState),
        "lowPowerMode": process.isLowPowerModeEnabled,
      ],
      "Battery": [
        "levelPercent": device.batteryLevel < 0
          ? "unavailable"
          : Int((device.batteryLevel * 100).rounded()),
        "state": batteryStateName(device.batteryState),
      ],
      "Display (native)": [
        "nativeWidth": Int(UIScreen.main.nativeBounds.width),
        "nativeHeight": Int(UIScreen.main.nativeBounds.height),
        "nativeScale": UIScreen.main.nativeScale,
        "brightness": UIScreen.main.brightness,
      ],
      "Regional settings": [
        "language": Locale.current.languageCode ?? "unavailable",
        "locale": Locale.current.identifier,
        "preferredLanguages": Locale.preferredLanguages,
        "timeZone": TimeZone.current.identifier,
        "calendar": Calendar.current.identifier.debugDescription,
      ],
    ]
  }

  private var isSimulator: Bool {
#if targetEnvironment(simulator)
    return true
#else
    return false
#endif
  }

  private func machineIdentifier() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machine = Mirror(reflecting: systemInfo.machine)
    return machine.children.reduce(into: "") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return }
      identifier += String(UnicodeScalar(UInt8(value)))
    }
  }

  private func batteryStateName(_ state: UIDevice.BatteryState) -> String {
    switch state {
    case .charging: return "charging"
    case .full: return "full"
    case .unplugged: return "unplugged"
    case .unknown: return "unknown"
    @unknown default: return "unknown"
    }
  }

  private func thermalStateName(_ state: ProcessInfo.ThermalState) -> String {
    switch state {
    case .nominal: return "nominal"
    case .fair: return "fair"
    case .serious: return "serious"
    case .critical: return "critical"
    @unknown default: return "unknown"
    }
  }
}
