import 'enums.dart';

/// Options for [VnptEkyc.start]. Unset (null) options keep the native SDK default.
class VnptEkycConfig {
  const VnptEkycConfig({
    required this.accessToken,
    required this.tokenId,
    required this.tokenKey,
    this.documentType,
    this.faceMode,
    this.language,
    this.challengeCode,
    this.inputClientSession,
    this.businessFlow,
    this.transactionId,
    this.transactionPartnerId,
    this.showTutorial,
    this.enableGotIt,
    this.showRequiredPermissionDecree,
    this.enableScanQrCode,
    this.validateDocument,
    this.validatePostcode,
    this.checkLivenessCard,
    this.blockedDocuments,
    this.skipPreview,
    this.livenessMode,
    this.checkMaskedFace,
    this.faceOvalMode,
    this.cameraPositionForPortrait,
    this.zoomCamera,
    this.enableCompare,
    this.hashImageCompare,
    this.enableCompareGeneral,
    this.thresLevel,
    this.hashFrontOcr,
    this.timeoutCallApiSeconds,
    this.enableCheckVirtualCamera,
    this.enableCheckEmulator,
    this.enableCheckRooted,
    this.headers,
    this.changeBaseUrl,
    this.offline,
  });

  /// Full header value, including the `Bearer ` prefix.
  final String accessToken;
  final String tokenId;
  final String tokenKey;

  final VnptDocumentType? documentType;
  final VnptFaceMode? faceMode;
  final VnptLanguage? language;

  /// Echoed back in the server responses so the client can detect tampering.
  final String? challengeCode;

  /// Links the steps of several flows into one session. Take it from the
  /// previous [VnptEkycResult.clientSession].
  final String? inputClientSession;
  final VnptBusinessFlow? businessFlow;
  final String? transactionId;
  final String? transactionPartnerId;

  final bool? showTutorial;

  /// Shows a "Got it" button to skip the tutorial video on the document/portrait
  /// help screen. Only relevant when [showTutorial] is true. Default false.
  final bool? enableGotIt;
  final bool? showRequiredPermissionDecree;

  /// Opens the QR scan screen before the front capture. Chip-based ID only.
  final bool? enableScanQrCode;
  final VnptValidateDocument? validateDocument;

  /// Returns province/district/ward codes resolved from the OCR result.
  final bool? validatePostcode;
  final bool? checkLivenessCard;
  final List<VnptBlockedDocument>? blockedDocuments;
  final bool? skipPreview;

  final VnptLivenessMode? livenessMode;
  final bool? checkMaskedFace;
  final VnptFaceOvalMode? faceOvalMode;
  final VnptCameraPosition? cameraPositionForPortrait;

  /// 1.0 to 3.0.
  final double? zoomCamera;

  /// Compare the portrait with [hashImageCompare] (usually the ID front).
  final bool? enableCompare;
  final String? hashImageCompare;

  /// Compare two face photos instead of ID front vs portrait.
  final bool? enableCompareGeneral;

  /// `strict`, `normal` or `easy`. Used with [enableCompareGeneral].
  final String? thresLevel;

  /// Hash of the front image; required by [VnptEkycFlow.ocrBack].
  final String? hashFrontOcr;

  final int? timeoutCallApiSeconds;
  final bool? enableCheckVirtualCamera;
  final bool? enableCheckEmulator;

  /// Root on Android, jailbreak on iOS.
  final bool? enableCheckRooted;

  /// Extra HTTP headers sent by the SDK.
  final Map<String, String>? headers;

  /// Overrides the API base URL.
  final String? changeBaseUrl;

  /// Skips every VNPT server call (OCR, compare, liveness, mask, QR hash upload).
  ///
  /// With this on, [accessToken], [tokenId] and [tokenKey] can be empty strings:
  /// nothing is sent to VNPT, so no real credentials are needed. Useful to test
  /// the capture UI and this plugin's wiring before a token is issued.
  ///
  /// The result will only carry image paths, the raw QR string and the
  /// recorded video path — [VnptEkycResult.ocrResult], `compareFaceResult`,
  /// `livenessFaceResult` etc. stay null. Mirrors `IS_TURN_OFF_CALL_SERVICE`
  /// (Android) / `isTurnOffCallService` (iOS). Default false.
  final bool? offline;

  Map<String, Object?> toMap() => <String, Object?>{
    'accessToken': accessToken,
    'tokenId': tokenId,
    'tokenKey': tokenKey,
    'documentType': documentType?.name,
    'faceMode': faceMode?.name,
    'language': language?.name,
    'challengeCode': challengeCode,
    'inputClientSession': inputClientSession,
    'businessFlow': businessFlow?.name,
    'transactionId': transactionId,
    'transactionPartnerId': transactionPartnerId,
    'showTutorial': showTutorial,
    'enableGotIt': enableGotIt,
    'showRequiredPermissionDecree': showRequiredPermissionDecree,
    'enableScanQrCode': enableScanQrCode,
    'validateDocument': validateDocument?.name,
    'validatePostcode': validatePostcode,
    'checkLivenessCard': checkLivenessCard,
    'blockedDocuments': blockedDocuments?.map((e) => e.name).toList(),
    'skipPreview': skipPreview,
    'livenessMode': livenessMode?.name,
    'checkMaskedFace': checkMaskedFace,
    'faceOvalMode': faceOvalMode?.name,
    'cameraPositionForPortrait': cameraPositionForPortrait?.name,
    'zoomCamera': zoomCamera,
    'enableCompare': enableCompare,
    'hashImageCompare': hashImageCompare,
    'enableCompareGeneral': enableCompareGeneral,
    'thresLevel': thresLevel,
    'hashFrontOcr': hashFrontOcr,
    'timeoutCallApiSeconds': timeoutCallApiSeconds,
    'enableCheckVirtualCamera': enableCheckVirtualCamera,
    'enableCheckEmulator': enableCheckEmulator,
    'enableCheckRooted': enableCheckRooted,
    'headers': headers,
    'changeBaseUrl': changeBaseUrl,
    'offline': offline,
  }..removeWhere((_, v) => v == null);
}
