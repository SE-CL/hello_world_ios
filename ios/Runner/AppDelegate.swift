import Flutter
import UIKit
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(name: "com.secl.hello_world_ios/vision", binaryMessenger: engineBridge.binaryMessenger)
    channel.setMethodCallHandler { call, result in
      guard call.method == "recognizeDigits", let data = call.arguments as? FlutterStandardTypedData,
            let image = UIImage(data: data.data), let cgImage = image.cgImage else {
        result(FlutterMethodNotImplemented); return
      }
      let request = VNRecognizeTextRequest { request, error in
        if let error { result(FlutterError(code: "OCR_ERROR", message: error.localizedDescription, details: nil)); return }
        let values = (request.results as? [VNRecognizedTextObservation] ?? []).compactMap { $0.topCandidates(1).first?.string }
        result(values)
      }
      request.recognitionLevel = .fast
      request.usesLanguageCorrection = false
      request.minimumTextHeight = 0.015
      DispatchQueue.global(qos: .userInitiated).async {
        do { try VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request]) }
        catch { result(FlutterError(code: "OCR_ERROR", message: error.localizedDescription, details: nil)) }
      }
    }
  }
}
