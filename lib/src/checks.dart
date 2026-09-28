import 'json_envelope.dart';

/// Result of a face-compare check (`VnptEkycResult.compareFaceResult`).
///
/// Field names follow VNPT's `CompareFaceObject` model. VNPT does not publicly
/// document the exact values [result] takes, so this only structures the JSON —
/// it does not decide pass/fail for you. Confirm the actual values with a live
/// response (or VNPT support) before branching business logic on them, and treat
/// this as informational: the authoritative accept/reject decision for an eKYC
/// case should be made by your backend re-checking with VNPT, not the client SDK.
class VnptFaceCompare {
  const VnptFaceCompare({
    this.message,
    this.result,
    this.probability,
    this.multipleFaces,
  });

  static VnptFaceCompare? tryParse(String? json) {
    final data = unwrapVnptJson(json);
    if (data == null) return null;
    final prob = data['prob'];
    return VnptFaceCompare(
      message: stringField(data, 'msg'),
      result: stringField(data, 'result'),
      probability: prob is num ? prob.toDouble() : null,
      multipleFaces: data['multiple_faces'] as bool?,
    );
  }

  final String? message;

  /// Raw match outcome as returned by VNPT. See the class doc: not documented publicly.
  final String? result;

  /// Similarity score. Range/scale not documented by VNPT.
  final double? probability;
  final bool? multipleFaces;

  Map<String, Object?> toJson() => <String, Object?>{
    'message': message,
    'result': result,
    'probability': probability,
    'multipleFaces': multipleFaces,
  }..removeWhere((_, v) => v == null);
}

/// Result of a liveness check — used for `livenessFaceResult`,
/// `livenessCardFrontResult` and `livenessCardBackResult`, which all share this shape.
///
/// Field names follow VNPT's `LivenessResult` model. See [VnptFaceCompare]'s doc:
/// the values of [liveness] are not documented publicly by VNPT — verify with a
/// live response before branching on them.
class VnptLiveness {
  const VnptLiveness({
    this.message,
    this.liveness,
    this.isEyeOpen,
    this.faceSwapping,
    this.fakeLiveness,
    this.blurFace,
  });

  static VnptLiveness? tryParse(String? json) {
    final data = unwrapVnptJson(json);
    if (data == null) return null;
    return VnptLiveness(
      message: stringField(data, 'liveness_msg'),
      liveness: stringField(data, 'liveness'),
      isEyeOpen: stringField(data, 'is_eye_open'),
      faceSwapping: data['face_swapping'] as bool?,
      fakeLiveness: data['fake_liveness'] as bool?,
      blurFace: stringField(data, 'blur_face'),
    );
  }

  final String? message;

  /// Raw liveness outcome as returned by VNPT. See the class doc: not documented publicly.
  final String? liveness;
  final String? isEyeOpen;
  final bool? faceSwapping;
  final bool? fakeLiveness;
  final String? blurFace;

  Map<String, Object?> toJson() => <String, Object?>{
    'message': message,
    'liveness': liveness,
    'isEyeOpen': isEyeOpen,
    'faceSwapping': faceSwapping,
    'fakeLiveness': fakeLiveness,
    'blurFace': blurFace,
  }..removeWhere((_, v) => v == null);
}

/// Result of the masked-face check (`VnptEkycResult.maskedFaceResult`).
///
/// Field name follows VNPT's `MaskedObject` model. See [VnptFaceCompare]'s doc:
/// the value of [masked] is not documented publicly by VNPT.
class VnptMaskCheck {
  const VnptMaskCheck({this.masked});

  static VnptMaskCheck? tryParse(String? json) {
    final data = unwrapVnptJson(json);
    if (data == null) return null;
    return VnptMaskCheck(masked: stringField(data, 'masked'));
  }

  final String? masked;

  Map<String, Object?> toJson() =>
      <String, Object?>{'masked': masked}..removeWhere((_, v) => v == null);
}
