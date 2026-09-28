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
            "compareQrCodeOcr": d.compareQRCodeOCRResult,
            "clientSession": d.clientSessionResult,
            "transactionId": d.transactionId,
            "transactionPartnerId": d.transactionPartnerId,
            "networkProblem": d.networkProblem,
            "pathImageFront": path(d, "pathImageFrontFull"),
            "pathImageFrontCropped": path(d, "pathImageFrontCropped"),
            "pathImageBack": path(d, "pathImageBackFull"),
            "pathImageBackCropped": path(d, "pathImageBackCropped"),
            "pathImageFace": path(d, "pathImageFaceFull"),
            "pathImageFaceNear": path(d, "pathImageFaceNearFull"),
            "pathImageFaceFar": path(d, "pathImageFaceFarFull"),
            "pathImageQrCode": path(d, "pathImageQRCodeFull"),
            "pathImageQrCodeCropped": path(d, "pathImageQRCodeCropped"),
            "hashImageFront": d.hashImageFront,
            "hashImageBack": d.hashImageBack,
            "hashImageFace": d.hashImageFace,
            "hashImageFaceNear": d.hashImageFaceNear,
            "hashImageFaceFar": d.hashImageFaceFar,
            "hashImageQrCode": d.hashImageQRCode,
            "hashFaceScan3d": d.hashDataScan3D,
        ]
    }

    // The SDK declares these NSURL properties non-null but leaves them nil for steps that did not run.
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
