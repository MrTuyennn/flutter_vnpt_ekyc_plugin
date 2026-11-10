import Flutter
import ICSdkEKYC
import UIKit

struct EkycArgumentError: Error {
    let message: String
}

enum EkycCameraFactory {
    static func make(flow: String?, config: [String: Any]) throws -> ICEkycCameraViewController {
        guard let camera = ICEkycCameraRouter.createModule() as? ICEkycCameraViewController else {
            throw EkycArgumentError(message: "Không tạo được module camera eKYC.")
        }

        camera.flowType = try flowType(flow)
        camera.accessToken = try required(config, "accessToken")
        camera.tokenId = try required(config, "tokenId")
        camera.tokenKey = try required(config, "tokenKey")

        if let v = try pick(config, "documentType", documentTypes) { camera.documentType = v }
        if let v = try pick(config, "faceMode", faceModes) { camera.versionSdk = v }
        if let v = try pick(config, "language", languages) { camera.languageSdk = v }
        if let v = try pick(config, "businessFlow", businessFlows) { camera.flowEKYC = v }
        if let v = try pick(config, "validateDocument", validations) { camera.validateDocumentType = v }
        if let v = try pick(config, "livenessMode", livenessModes) { camera.checkLivenessFace = v }
        if let v = try pick(config, "faceOvalMode", ovalModes) { camera.modeVersionFaceOval = v }
        if let v = try pick(config, "cameraPositionForPortrait", cameras) { camera.cameraPositionForPortrait = v }

        if let v = config["challengeCode"] as? String { camera.challengeCode = v }
        if let v = config["inputClientSession"] as? String { camera.inputClientSession = v }
        if let v = config["transactionId"] as? String { camera.transactionId = v }
        if let v = config["transactionPartnerId"] as? String { camera.transactionPartnerId = v }
        if let v = config["hashImageCompare"] as? String { camera.hashImageCompare = v }
        if let v = config["thresLevel"] as? String { camera.thresLevel = v }
        if let v = config["hashFrontOcr"] as? String { camera.hashFrontOCR = v }
        if let v = config["changeBaseUrl"] as? String { camera.changeBaseUrl = v }

        if let v = config["showTutorial"] as? Bool { camera.isShowTutorial = v }
        if let v = config["enableGotIt"] as? Bool { camera.isEnableGotIt = v }
        if let v = config["showRequiredPermissionDecree"] as? Bool { camera.isShowRequiredPermissionDecree = v }
        if let v = config["enableScanQrCode"] as? Bool { camera.isEnableScanQRCode = v }
        if let v = config["validatePostcode"] as? Bool { camera.isValidatePostcode = v }
        if let v = config["checkLivenessCard"] as? Bool { camera.isCheckLivenessCard = v }
        if let v = config["skipPreview"] as? Bool { camera.isSkipPreview = v }
        if let v = config["checkMaskedFace"] as? Bool { camera.isCheckMaskedFace = v }
        if let v = config["enableCompare"] as? Bool { camera.isEnableCompare = v }
        if let v = config["enableCompareGeneral"] as? Bool { camera.isCompareGeneral = v }
        if let v = config["enableCheckVirtualCamera"] as? Bool { camera.isEnableCheckVirtualCamera = v }
        if let v = config["enableCheckEmulator"] as? Bool { camera.isEnableCheckSimulator = v }
        if let v = config["enableCheckRooted"] as? Bool { camera.isEnableCheckJailbroken = v }
        if let v = config["offline"] as? Bool { camera.isTurnOffCallService = v }

        if let v = config["zoomCamera"] as? NSNumber { camera.zoomCamera = CGFloat(truncating: v) }
        if let v = config["timeoutCallApiSeconds"] as? NSNumber { camera.timeoutCallApi = v.intValue }

        if let names = config["blockedDocuments"] as? [String] {
            let values = try names.map { name -> NSNumber in
                guard let doc = blockedDocuments[name] else {
                    throw EkycArgumentError(message: "Loại giấy tờ bị chặn không xác định: \(name)")
                }
                return NSNumber(value: doc.rawValue)
            }
            camera.listBlockedDocument = NSMutableArray(array: values)
        }

        if let headers = config["headers"] as? [String: String] {
            camera.headersRequest = NSMutableDictionary(dictionary: headers)
        }

        if let theme = config["theme"] as? [String: Any] {
            applyTheme(camera, theme)
        }

        return camera
    }

    private static func applyTheme(_ camera: ICEkycCameraViewController, _ theme: [String: Any]) {
        if let v = color(theme, "headerContentColor") { camera.contentColorHeaderBar = v }
        if let v = color(theme, "headerBackgroundColor") { camera.backgroundColorHeaderBar = v }
        if let v = color(theme, "mainContentColor") { camera.textColorContentMain = v }
        if let v = color(theme, "mainTitleColor") { camera.titleColorMain = v }
        if let v = color(theme, "mainBackgroundColor") { camera.backgroundColorMainScreen = v }
        if let v = color(theme, "lineColor") { camera.backgroundColorLine = v }
        if let v = color(theme, "activeButtonBackgroundColor") { camera.backgroundColorActiveButton = v }
        if let v = color(theme, "activeButtonTitleColor") { camera.titleColorActiveButton = v }
        if let v = color(theme, "inactiveButtonBackgroundColor") { camera.backgroundColorDeactiveButton = v }
        if let v = color(theme, "inactiveButtonTitleColor") { camera.titleColorDeactiveButton = v }
        if let v = color(theme, "documentCaptureBackgroundColor") { camera.backgroundColorCaptureDocumentScreen = v }
        if let v = color(theme, "faceCaptureBackgroundColor") { camera.backgroundColorCaptureFaceScreen = v }
        if let v = color(theme, "faceNoticeEffectColor") { camera.effectColorNoticeFace = v }
        if let v = color(theme, "faceNoticeTextColor") { camera.textColorNoticeFace = v }
        if let v = color(theme, "validDocumentEffectColor") { camera.effectColorNoticeValidDocument = v }
        if let v = color(theme, "validDocumentTextColor") { camera.textColorNoticeValidDocument = v }
        if let v = color(theme, "invalidDocumentEffectColor") { camera.effectColorNoticeInvalidDocument = v }
        if let v = color(theme, "invalidDocumentTextColor") { camera.textColorNoticeInvalidDocument = v }
        if let v = color(theme, "captureButtonTintColor") { camera.tintColorButtonCapture = v }
        if let v = color(theme, "faceBorderColor") { camera.backgroundColorBorderCaptureFace = v }
        if let v = color(theme, "popupBackgroundColor") { camera.backgroundColorPopup = v }
        if let v = color(theme, "popupTextColor") { camera.textColorContentPopup = v }
        // Chỉ có hiệu lực trên iOS — Android không có màn hình flash riêng.
        if let v = color(theme, "flashBackgroundColor") { camera.backgroundColorFlash = v }
        if let v = color(theme, "flashTitleColor") { camera.colorTitleFlash = v }

        if let name = theme["headerButtonPosition"] as? String {
            switch name {
            case "left": camera.modeButtonHeaderBar = LeftButton
            case "right": camera.modeButtonHeaderBar = RightButton
            default:
                break
            }
        }

        if let v = image(theme, "logo") { camera.logo = v }
        if let v = image(theme, "logoFaceOval") { camera.logoFaceOval = v }
        if let v = image(theme, "tutorialQrCodeImage") { camera.imageTutorialQRCode = v }
        if let v = image(theme, "tutorialFrontImage") { camera.imageTutorialFront = v }
        if let v = image(theme, "tutorialBackImage") { camera.imageTutorialBack = v }
        if let v = image(theme, "tutorialBlurImage") { camera.imageTutorialBlur = v }
        if let v = image(theme, "tutorialGlareImage") { camera.imageTutorialGlare = v }
        if let v = image(theme, "tutorialLostAngleImage") { camera.imageTutorialLostAngle = v }

        if let v = theme["logoWidth"] as? NSNumber { camera.widthLogo = CGFloat(truncating: v) }
        if let v = theme["logoHeight"] as? NSNumber { camera.heightLogo = CGFloat(truncating: v) }
        if let v = theme["showLogo"] as? Bool { camera.isShowLogo = v }
        // logoFaceOvalWidth/logoFaceOvalHeight, headerBarCornerRadius, buttonCornerRadius,
        // loadingEffectColor, loadingBackgroundColor: chỉ có hiệu lực trên Android, SDK iOS
        // không có property tương ứng.
    }

    // Số nguyên ARGB (ví dụ 0xFF00A96F) — cùng định dạng Android ColorInt đang dùng.
    private static func color(_ theme: [String: Any], _ key: String) -> UIColor? {
        guard let v = theme[key] as? NSNumber else { return nil }
        let argb = v.intValue
        return UIColor(
            red: CGFloat((argb >> 16) & 0xFF) / 255,
            green: CGFloat((argb >> 8) & 0xFF) / 255,
            blue: CGFloat(argb & 0xFF) / 255,
            alpha: CGFloat((argb >> 24) & 0xFF) / 255
        )
    }

    // iOS nhận ảnh trực tiếp qua bytes (VnptEkycImage.bytes); androidDrawableName bị bỏ qua.
    private static func image(_ theme: [String: Any], _ key: String) -> UIImage? {
        guard let entry = theme[key] as? [String: Any] else { return nil }
        guard let typedData = entry["bytes"] as? FlutterStandardTypedData else { return nil }
        return UIImage(data: typedData.data)
    }

    // Chuỗi rỗng là giá trị mặc định của chính native SDK nên được chấp nhận, ví dụ khi
    // config.offline bật và không cần credentials VNPT.
    private static func required(_ config: [String: Any], _ key: String) throws -> String {
        guard let value = config[key] as? String else {
            throw EkycArgumentError(message: "config.\(key) là bắt buộc")
        }
        return value
    }

    private static func pick<T>(_ config: [String: Any], _ key: String, _ table: [String: T]) throws -> T? {
        guard let name = config[key] as? String else { return nil }
        guard let value = table[name] else {
            throw EkycArgumentError(message: "\(key) không xác định: \(name)")
        }
        return value
    }

    private static func flowType(_ name: String?) throws -> FlowType {
        switch name {
        case "full": return full
        case "ocr": return ocr
        case "ocrFront": return ocrFront
        case "ocrBack": return ocrBack
        case "face": return face
        case "qrCode": return scanQR
        default: throw EkycArgumentError(message: "Flow không xác định: \(name ?? "nil")")
        }
    }

    private static let documentTypes: [String: TypeDocument] = [
        "identityCard": IdentityCard,
        "identityCardChip": IDCardChipBased,
        "passport": Passport,
        "driverLicense": DriverLicense,
        "militaryCard": MilitaryIdCard,
    ]
    private static let faceModes: [String: VersionSdk] = ["standard": Normal, "advanced": ProOval]
    private static let languages: [String: String] = ["vietnamese": "icekyc_vi", "english": "icekyc_en"]
    private static let businessFlows: [String: ICEKYCFlow] = [
        "ntb": ICEKYCNTB, "etb": ICEKYCETB, "verify": ICEKYCVERIFY,
    ]
    private static let validations: [String: TypeValidateDocument] = [
        "none": None, "basic": Basic, "medium": Medium, "advance": Advance,
    ]
    private static let livenessModes: [String: ModeCheckLivenessFace] = [
        "none": NoneCheckFace, "iBeta": IBeta, "standard": Standard,
    ]
    private static let ovalModes: [String: VersionFaceOval] = [
        "farAndNear": FarAndNear, "farOnly": OnlyFar, "nearOnly": OnlyNear,
    ]
    private static let cameras: [String: CameraPosition] = [
        "front": PositionFront, "back": PositionBack,
    ]
    private static let blockedDocuments: [String: BlockedDocumentType] = [
        "identityCard9": IDENTITY_CARD_9,
        "identityCard12": IDENTITY_CARD_12,
        "citizenIdCard": CITIZEN_ID_CARD,
        "passport": PASSPORT,
        "militaryCard": MILITARY_CARD,
        "driverLicense": DRIVER_LICENSE,
        "citizenIdChip": CITIZEN_ID_CHIP,
        "citizenIdChip01072024": CITIZEN_ID_CHIP_01072024,
    ]
}
