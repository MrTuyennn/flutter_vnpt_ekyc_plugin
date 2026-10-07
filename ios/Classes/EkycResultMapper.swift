import ICSdkEKYC

enum EkycResultMapper {
    static func completed(_ d: ICEKYCSavedData) -> [String: Any?] {
        [
            "status": "completed",
            "ocrResult": d.ocrResult,
            "compareFaceResult": d.compareFaceResult,
            "livenessFaceResult": d.livenessFaceResult,
            "maskedFaceResult": d.maskedFaceResult,
            "livenessCardFrontResult": d.livenessCardFrontResult,
            "livenessCardBackResult": d.livenessCardBackResult,
            "qrCodeResult": d.qrCodeResult,
            "qrCodeResultDetail": d.qrCodeResultDetail,
            "retryQrCodeResult": d.retryQRCodeResult,
            // compareQRCodeOCRResult is a plain BOOL with no "unset" state on iOS.
            // Mirror Android (which keys off Intent.hasExtra) by treating it as unset
            // whenever the QR step never produced a result.
            "compareQrCodeOcr": qrCodeRan(d) ? d.compareQRCodeOCRResult : nil,
            "clientSession": d.clientSessionResult,
            "transactionId": d.transactionId,
            "transactionPartnerId": d.transactionPartnerId,
            "networkProblem": d.networkProblem,
            "pathImageFront": path(d, #keyPath(ICEKYCSavedData.pathImageFrontFull)),
            "pathImageFrontCropped": path(d, #keyPath(ICEKYCSavedData.pathImageFrontCropped)),
            "pathImageBack": path(d, #keyPath(ICEKYCSavedData.pathImageBackFull)),
            "pathImageBackCropped": path(d, #keyPath(ICEKYCSavedData.pathImageBackCropped)),
            "pathImageFace": path(d, #keyPath(ICEKYCSavedData.pathImageFaceFull)),
            "pathImageFaceNear": path(d, #keyPath(ICEKYCSavedData.pathImageFaceNearFull)),
            "pathImageFaceFar": path(d, #keyPath(ICEKYCSavedData.pathImageFaceFarFull)),
            "pathImageQrCode": path(d, #keyPath(ICEKYCSavedData.pathImageQRCodeFull)),
            "pathImageQrCodeCropped": path(d, #keyPath(ICEKYCSavedData.pathImageQRCodeCropped)),
            "hashImageFront": d.hashImageFront,
            "hashImageBack": d.hashImageBack,
            "hashImageFace": d.hashImageFace,
            "hashImageFaceNear": d.hashImageFaceNear,
            "hashImageFaceFar": d.hashImageFaceFar,
            "hashImageQrCode": d.hashImageQRCode,
            "hashFaceScan3d": d.hashDataScan3D,
        ]
    }

    private static func qrCodeRan(_ d: ICEKYCSavedData) -> Bool {
        !(d.qrCodeResult?.isEmpty ?? true)
    }

    // The SDK declares these NSURL properties non-null but leaves them nil for steps that did not run.
    // Direct property access would trap on that unexpected nil, so we go through KVC instead;
    // callers pass #keyPath(...) so a typo or SDK rename is still caught at compile time.
    private static func path(_ d: ICEKYCSavedData, _ key: String) -> String? {
        (d.value(forKey: key) as? URL)?.path
    }

    static func stepName(_ type: ScreenType) -> String {
        switch type {
        case CancelPermission: return "CancelPermission"
        case HelpDocument: return "HelpDocument"
        case ScanQRCode: return "ScanQRCode"
        case ScanQRCodeFailed: return "ScanQRCodeFailed"
        case CaptureFront: return "CaptureFront"
        case CaptureBack: return "CaptureBack"
        case HelpOval: return "HelpOval"
        case AuthenFarFace: return "AuthenFarFace"
        case AuthenNearFace: return "AuthenNearFace"
        case HelpFaceBasic: return "HelpFaceBasic"
        case CaptureFaceBasic: return "CaptureFaceBasic"
        case Processing: return "Processing"
        default: return "Unknown"
        }
    }
}
