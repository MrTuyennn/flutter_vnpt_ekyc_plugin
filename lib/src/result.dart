import 'checks.dart';
import 'identity.dart';

enum VnptEkycStatus {
  /// Flow đã chạy xong và các field kết quả đã có dữ liệu.
  completed,

  /// Người dùng thoát khỏi SDK trước khi flow chạy xong.
  cancelled,
}

/// Kết quả trả về của [VnptEkyc.start].
///
/// Các chuỗi `*Result` là JSON thô do service VNPT trả về. Đường dẫn ảnh trỏ tới file
/// trong sandbox của app; nhớ xoá khi dùng xong (xem [imagePaths]).
class VnptEkycResult {
  const VnptEkycResult({
    required this.status,
    this.lastStep,
    this.ocrResult,
    this.compareFaceResult,
    this.livenessFaceResult,
    this.maskedFaceResult,
    this.livenessCardFrontResult,
    this.livenessCardBackResult,
    this.qrCodeResult,
    this.qrCodeResultDetail,
    this.retryQrCodeResult,
    this.compareQrCodeOcr,
    this.clientSession,
    this.transactionId,
    this.transactionPartnerId,
    this.networkProblem,
    this.errorClient = const <String>[],
    this.pathImageFront,
    this.pathImageFrontCropped,
    this.pathImageBack,
    this.pathImageBackCropped,
    this.pathImageFace,
    this.pathImageFaceNear,
    this.pathImageFaceFar,
    this.pathImageQrCode,
    this.pathImageQrCodeCropped,
    this.hashImageFront,
    this.hashImageBack,
    this.hashImageFace,
    this.hashImageFaceNear,
    this.hashImageFaceFar,
    this.hashImageQrCode,
    this.hashFaceScan3d,
  });

  factory VnptEkycResult.fromMap(Map<Object?, Object?> map) {
    String? s(String key) {
      final value = map[key];
      return value is String && value.isNotEmpty ? value : null;
    }

    final errors = map['errorClient'];
    return VnptEkycResult(
      status: map['status'] == 'completed'
          ? VnptEkycStatus.completed
          : VnptEkycStatus.cancelled,
      lastStep: s('lastStep'),
      ocrResult: s('ocrResult'),
      compareFaceResult: s('compareFaceResult'),
      livenessFaceResult: s('livenessFaceResult'),
      maskedFaceResult: s('maskedFaceResult'),
      livenessCardFrontResult: s('livenessCardFrontResult'),
      livenessCardBackResult: s('livenessCardBackResult'),
      qrCodeResult: s('qrCodeResult'),
      qrCodeResultDetail: s('qrCodeResultDetail'),
      retryQrCodeResult: s('retryQrCodeResult'),
      compareQrCodeOcr: map['compareQrCodeOcr'] as bool?,
      clientSession: s('clientSession'),
      transactionId: s('transactionId'),
      transactionPartnerId: s('transactionPartnerId'),
      networkProblem: s('networkProblem'),
      errorClient: errors is List
          ? errors.whereType<String>().toList(growable: false)
          : const <String>[],
      pathImageFront: s('pathImageFront'),
      pathImageFrontCropped: s('pathImageFrontCropped'),
      pathImageBack: s('pathImageBack'),
      pathImageBackCropped: s('pathImageBackCropped'),
      pathImageFace: s('pathImageFace'),
      pathImageFaceNear: s('pathImageFaceNear'),
      pathImageFaceFar: s('pathImageFaceFar'),
      pathImageQrCode: s('pathImageQrCode'),
      pathImageQrCodeCropped: s('pathImageQrCodeCropped'),
      hashImageFront: s('hashImageFront'),
      hashImageBack: s('hashImageBack'),
      hashImageFace: s('hashImageFace'),
      hashImageFaceNear: s('hashImageFaceNear'),
      hashImageFaceFar: s('hashImageFaceFar'),
      hashImageQrCode: s('hashImageQrCode'),
      hashFaceScan3d: s('hashFaceScan3d'),
    );
  }

  final VnptEkycStatus status;

  /// Màn hình mà người dùng thoát ra khi [status] là [VnptEkycStatus.cancelled].
  /// Giá trị tuỳ theo nền tảng (`Capture_Front` trên Android, `CaptureFront` trên iOS).
  final String? lastStep;

  final String? ocrResult;
  final String? compareFaceResult;
  final String? livenessFaceResult;
  final String? maskedFaceResult;
  final String? livenessCardFrontResult;
  final String? livenessCardBackResult;
  final String? qrCodeResult;
  final String? qrCodeResultDetail;
  final String? retryQrCodeResult;

  /// True khi số giấy tờ, tên, giới tính, ngày sinh giữa QR và OCR đều khớp nhau.
  final bool? compareQrCodeOcr;

  /// Truyền vào flow kế tiếp dưới dạng [VnptEkycConfig.inputClientSession].
  final String? clientSession;
  final String? transactionId;
  final String? transactionPartnerId;

  /// `timeout` khi SDK không kết nối được tới server.
  final String? networkProblem;

  /// Chỉ có trên Android: `Simulator`, `RootedDevice`, `VirtualCamera`.
  final List<String> errorClient;

  final String? pathImageFront;
  final String? pathImageFrontCropped;
  final String? pathImageBack;
  final String? pathImageBackCropped;
  final String? pathImageFace;
  final String? pathImageFaceNear;
  final String? pathImageFaceFar;
  final String? pathImageQrCode;
  final String? pathImageQrCodeCropped;

  final String? hashImageFront;
  final String? hashImageBack;
  final String? hashImageFace;
  final String? hashImageFaceNear;
  final String? hashImageFaceFar;
  final String? hashImageQrCode;
  final String? hashFaceScan3d;

  /// Dữ liệu cá nhân parse từ [ocrResult]; null khi flow không chạy OCR.
  VnptIdentity? get identity => VnptIdentity.tryParse(ocrResult);

  /// Dữ liệu cá nhân parse từ [qrCodeResult]; null khi không quét QR.
  VnptIdentity? get qrIdentity => VnptIdentity.tryParse(qrCodeResult);

  /// Kết quả so khớp khuôn mặt với giấy tờ (hoặc khuôn mặt với khuôn mặt) parse từ
  /// [compareFaceResult]. Null khi flow không chạy check so khớp. Xem doc của
  /// [VnptFaceCompare] — không tự quyết định đậu/rớt giúp bạn.
  VnptFaceCompare? get faceCompare =>
      VnptFaceCompare.tryParse(compareFaceResult);

  /// Kết quả check liveness của ảnh chân dung, parse từ [livenessFaceResult].
  /// Null khi flow không chạy check liveness. Xem doc của [VnptLiveness].
  VnptLiveness? get faceLiveness => VnptLiveness.tryParse(livenessFaceResult);

  /// Kết quả check liveness của ảnh mặt trước giấy tờ, parse từ [livenessCardFrontResult].
  VnptLiveness? get cardFrontLiveness =>
      VnptLiveness.tryParse(livenessCardFrontResult);

  /// Kết quả check liveness của ảnh mặt sau giấy tờ, parse từ [livenessCardBackResult].
  VnptLiveness? get cardBackLiveness =>
      VnptLiveness.tryParse(livenessCardBackResult);

  /// Kết quả check che mặt, parse từ [maskedFaceResult]. Xem doc của [VnptMaskCheck].
  VnptMaskCheck? get maskCheck => VnptMaskCheck.tryParse(maskedFaceResult);

  /// Toàn bộ file ảnh mà SDK để lại trên bộ nhớ máy. App tự chịu trách nhiệm xoá.
  Iterable<String> get imagePaths => <String?>[
    pathImageFront,
    pathImageFrontCropped,
    pathImageBack,
    pathImageBackCropped,
    pathImageFace,
    pathImageFaceNear,
    pathImageFaceFar,
    pathImageQrCode,
    pathImageQrCodeCropped,
  ].whereType<String>();
}
