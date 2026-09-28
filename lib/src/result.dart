import 'checks.dart';
import 'identity.dart';

enum VnptEkycStatus {
  /// The flow finished and the result fields are populated.
  completed,

  /// The user left the SDK before the flow finished.
  cancelled,
}

/// Result of [VnptEkyc.start].
///
/// The `*Result` strings are raw JSON returned by the VNPT service. Image paths
/// point to files in the app sandbox; delete them when done (see [imagePaths]).
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

  /// Screen the user left from when [status] is [VnptEkycStatus.cancelled].
  /// Values are platform specific (`Capture_Front` on Android, `CaptureFront` on iOS).
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

  /// True when ID number, name, gender and birth date of QR and OCR all match.
  final bool? compareQrCodeOcr;

  /// Pass to the next flow as [VnptEkycConfig.inputClientSession].
  final String? clientSession;
  final String? transactionId;
  final String? transactionPartnerId;

  /// `timeout` when the SDK could not reach the server.
  final String? networkProblem;

  /// Android only: `Simulator`, `RootedDevice`, `VirtualCamera`.
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

  /// Personal data parsed from [ocrResult]; null when the flow did no OCR.
  VnptIdentity? get identity => VnptIdentity.tryParse(ocrResult);

  /// Personal data parsed from [qrCodeResult]; null when no QR was scanned.
  VnptIdentity? get qrIdentity => VnptIdentity.tryParse(qrCodeResult);

  /// Parsed face-vs-document (or face-vs-face) match check from [compareFaceResult].
  /// Null when the flow did not run a compare check. See [VnptFaceCompare]'s doc —
  /// this does not decide pass/fail for you.
  VnptFaceCompare? get faceCompare =>
      VnptFaceCompare.tryParse(compareFaceResult);

  /// Parsed liveness check of the portrait capture from [livenessFaceResult].
  /// Null when the flow did not run a liveness check. See [VnptLiveness]'s doc.
  VnptLiveness? get faceLiveness => VnptLiveness.tryParse(livenessFaceResult);

  /// Parsed liveness check of the front document capture from [livenessCardFrontResult].
  VnptLiveness? get cardFrontLiveness =>
      VnptLiveness.tryParse(livenessCardFrontResult);

  /// Parsed liveness check of the back document capture from [livenessCardBackResult].
  VnptLiveness? get cardBackLiveness =>
      VnptLiveness.tryParse(livenessCardBackResult);

  /// Parsed masked-face check from [maskedFaceResult]. See [VnptMaskCheck]'s doc.
  VnptMaskCheck? get maskCheck => VnptMaskCheck.tryParse(maskedFaceResult);

  /// Every image file the SDK left on disk. The app is responsible for deleting them.
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
