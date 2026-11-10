import 'enums.dart';

/// Tuỳ chọn cho [VnptEkyc.start]. Option để trống (null) sẽ giữ nguyên giá trị mặc định của
/// native SDK.
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

  /// Giá trị đầy đủ của header, bao gồm cả tiền tố `Bearer `.
  final String accessToken;
  final String tokenId;
  final String tokenKey;

  final VnptDocumentType? documentType;
  final VnptFaceMode? faceMode;
  final VnptLanguage? language;

  /// Được server trả ngược lại trong response để client phát hiện giả mạo.
  final String? challengeCode;

  /// Nối các bước của nhiều flow vào chung một phiên. Lấy giá trị này từ
  /// [VnptEkycResult.clientSession] của lần gọi trước đó.
  final String? inputClientSession;
  final VnptBusinessFlow? businessFlow;
  final String? transactionId;
  final String? transactionPartnerId;

  final bool? showTutorial;

  /// Hiện nút "Đã hiểu" để bỏ qua video hướng dẫn ở màn hình trợ giúp chụp
  /// giấy tờ/chân dung. Chỉ có tác dụng khi [showTutorial] là true. Mặc định false.
  final bool? enableGotIt;
  final bool? showRequiredPermissionDecree;

  /// Mở màn hình quét QR trước bước chụp mặt trước. Chỉ áp dụng cho CCCD gắn chip.
  final bool? enableScanQrCode;
  final VnptValidateDocument? validateDocument;

  /// Trả về mã tỉnh/huyện/xã được suy ra từ kết quả OCR.
  final bool? validatePostcode;
  final bool? checkLivenessCard;
  final List<VnptBlockedDocument>? blockedDocuments;
  final bool? skipPreview;

  final VnptLivenessMode? livenessMode;
  final bool? checkMaskedFace;
  final VnptFaceOvalMode? faceOvalMode;
  final VnptCameraPosition? cameraPositionForPortrait;

  /// Từ 1.0 đến 3.0.
  final double? zoomCamera;

  /// So khớp ảnh chân dung với [hashImageCompare] (thường là ảnh mặt trước giấy tờ).
  final bool? enableCompare;
  final String? hashImageCompare;

  /// So sánh 2 ảnh khuôn mặt với nhau thay vì mặt trước giấy tờ với ảnh chân dung.
  final bool? enableCompareGeneral;

  /// `strict`, `normal` hoặc `easy`. Dùng cùng với [enableCompareGeneral].
  final String? thresLevel;

  /// Hash của ảnh mặt trước; bắt buộc phải có khi dùng [VnptEkycFlow.ocrBack].
  final String? hashFrontOcr;

  final int? timeoutCallApiSeconds;
  final bool? enableCheckVirtualCamera;
  final bool? enableCheckEmulator;

  /// Root trên Android, jailbreak trên iOS.
  final bool? enableCheckRooted;

  /// Header HTTP bổ sung được SDK gửi kèm.
  final Map<String, String>? headers;

  /// Ghi đè base URL của API.
  final String? changeBaseUrl;

  /// Bỏ qua mọi lệnh gọi server VNPT (OCR, so khớp mặt, liveness, che mặt, upload hash QR).
  ///
  /// Khi bật, [accessToken], [tokenId] và [tokenKey] có thể để chuỗi rỗng: không có gì được
  /// gửi lên VNPT, nên không cần token thật. Hữu ích để test giao diện chụp và việc kết nối
  /// plugin trước khi có token thật.
  ///
  /// Kết quả trả về lúc này chỉ có đường dẫn ảnh, chuỗi QR thô và đường dẫn video đã quay —
  /// [VnptEkycResult.ocrResult], `compareFaceResult`, `livenessFaceResult`... đều là null.
  /// Tương ứng với `IS_TURN_OFF_CALL_SERVICE` (Android) / `isTurnOffCallService` (iOS).
  /// Mặc định false.
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
