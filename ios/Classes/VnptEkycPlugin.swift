import Flutter
import ICSdkEKYC
import UIKit

public class VnptEkycPlugin: NSObject, FlutterPlugin, ICEkycCameraDelegate {
    private var pendingResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_vnpt_ekyc_plugin",
            binaryMessenger: registrar.messenger()
        )
        registrar.addMethodCallDelegate(VnptEkycPlugin(), channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard call.method == "start" else {
            result(FlutterMethodNotImplemented)
            return
        }
        guard pendingResult == nil else {
            result(FlutterError(code: "already_running", message: "An eKYC flow is already in progress.", details: nil))
            return
        }
        guard let args = call.arguments as? [String: Any],
              let config = args["config"] as? [String: Any] else {
            result(FlutterError(code: "invalid_argument", message: "config is required", details: nil))
            return
        }
        guard let presenter = Self.topViewController() else {
            result(FlutterError(code: "no_activity", message: "No view controller to present the SDK from.", details: nil))
            return
        }

        do {
            let camera = try EkycCameraFactory.make(flow: args["flow"] as? String, config: config)
            camera.cameraDelegate = self
            ICEKYCSavedData.shared().resetOrInitAllData()
            pendingResult = result
            camera.modalPresentationStyle = .fullScreen
            camera.modalTransitionStyle = .coverVertical
            presenter.present(camera, animated: true)
        } catch let error as EkycArgumentError {
            result(FlutterError(code: "invalid_argument", message: error.message, details: nil))
        } catch {
            result(FlutterError(code: "sdk_error", message: error.localizedDescription, details: nil))
        }
    }

    public func icEkycGetResult() {
        finish(EkycResultMapper.completed(ICEKYCSavedData.shared()))
    }

    public func icEkycCameraClosed(with type: ScreenType) {
        // Done is reported through icEkycGetResult.
        if type == Done { return }
        finish(["status": "cancelled", "lastStep": EkycResultMapper.stepName(type)])
    }

    private func finish(_ payload: [String: Any?]) {
        guard let result = pendingResult else { return }
        pendingResult = nil
        if Thread.isMainThread {
            result(payload)
        } else {
            DispatchQueue.main.async {
                result(payload)
            }
        }
    }

    private static func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        var top = scene?.windows.first { $0.isKeyWindow }?.rootViewController
        while let presented = top?.presentedViewController { top = presented }
        return top
    }
}
