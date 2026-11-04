import Flutter
import UIKit
import external_display

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    ExternalDisplayPlugin.registerGeneratedPlugin = registerGeneratedPlugin
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func registerGeneratedPlugin(controller: FlutterViewController) {
    GeneratedPluginRegistrant.register(with: controller)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}