import 'json_envelope.dart';

/// Kết quả check so khớp khuôn mặt (`VnptEkycResult.compareFaceResult`).
///
/// Tên field theo đúng model `CompareFaceObject` của VNPT. VNPT không công bố công khai các
/// giá trị cụ thể mà [result] có thể nhận, nên class này chỉ cấu trúc hoá lại JSON — không tự
/// quyết định đậu/rớt giúp bạn. Hãy xác nhận giá trị thật bằng response thật (hoặc hỏi VNPT
/// support) trước khi dùng để rẽ nhánh nghiệp vụ, và coi đây chỉ là thông tin tham khảo: quyết
/// định đậu/rớt chính thức cho một hồ sơ eKYC nên do backend của bạn tự kiểm tra lại với VNPT,
/// không phải SDK client.
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

  /// Kết quả so khớp thô do VNPT trả về. Xem doc của class: không được công bố công khai.
  final String? result;

  /// Điểm tương đồng. Khoảng giá trị/thang đo không được VNPT công bố.
  final double? probability;
  final bool? multipleFaces;

  Map<String, Object?> toJson() => <String, Object?>{
    'message': message,
    'result': result,
    'probability': probability,
    'multipleFaces': multipleFaces,
  }..removeWhere((_, v) => v == null);
}

/// Kết quả check liveness — dùng chung cho `livenessFaceResult`,
/// `livenessCardFrontResult` và `livenessCardBackResult`, cả 3 đều có cùng cấu trúc này.
///
/// Tên field theo đúng model `LivenessResult` của VNPT. Xem doc của [VnptFaceCompare]:
/// giá trị của [liveness] không được VNPT công bố công khai — hãy xác nhận bằng response
/// thật trước khi dùng để rẽ nhánh.
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

  /// Kết quả liveness thô do VNPT trả về. Xem doc của class: không được công bố công khai.
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

/// Kết quả check che mặt (`VnptEkycResult.maskedFaceResult`).
///
/// Tên field theo đúng model `MaskedObject` của VNPT. Xem doc của [VnptFaceCompare]:
/// giá trị của [masked] không được VNPT công bố công khai.
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
