/// Ghi đè URL của từng API riêng lẻ mà SDK native gọi tới — khác với
/// [VnptEkycConfig.changeBaseUrl] (chỉ đổi domain gốc, các path con vẫn cố định theo SDK).
/// Dùng khi path thật khác domain/khác nhau giữa các API (ví dụ: domain CCCD khác domain chân
/// dung), hoặc muốn trỏ từng API tới 1 service riêng.
///
/// Field nào không truyền (null) sẽ giữ URL mặc định của SDK (gọi thẳng server VNPT, hoặc theo
/// [VnptEkycConfig.changeBaseUrl] nếu có đặt).
///
/// Tên field lấy đúng theo VNPT công bố trong header SDK iOS (`ICEkycCameraViewController.h`) và
/// constant Android (`KeyIntentConstants`, đọc trực tiếp từ class file trong AAR qua `javap`).
class VnptEkycEndpoints {
  const VnptEkycEndpoints({
    this.uploadImage,
    this.ocr,
    this.ocrFront,
    this.compare,
    this.livenessFace,
    this.livenessCard,
    this.checkMaskedFace,
    this.logSdk,
    this.compareGeneral,
    this.verifyFace,
    this.addFace,
    this.addCardId,
    this.searchFace,
    this.livenessFace3D,
  });

  /// Tiện ích ghép [base] (domain chung) với path riêng của từng API, để không phải lặp lại
  /// domain ở mỗi field — ví dụ `VnptEkycEndpoints.fromBase('https://api.vi', ocrFront:
  /// '/cccd-front')` tương đương `VnptEkycEndpoints(ocrFront: 'https://api.vi/cccd-front')`.
  /// Việc ghép chuỗi diễn ra ngay ở Dart; native luôn nhận URL đầy đủ như khi dùng constructor
  /// thường, không liên quan gì tới [VnptEkycConfig.changeBaseUrl].
  factory VnptEkycEndpoints.fromBase(
    String base, {
    String? uploadImage,
    String? ocr,
    String? ocrFront,
    String? compare,
    String? livenessFace,
    String? livenessCard,
    String? checkMaskedFace,
    String? logSdk,
    String? compareGeneral,
    String? verifyFace,
    String? addFace,
    String? addCardId,
    String? searchFace,
    String? livenessFace3D,
  }) {
    String? join(String? path) => path == null ? null : '$base$path';
    return VnptEkycEndpoints(
      uploadImage: join(uploadImage),
      ocr: join(ocr),
      ocrFront: join(ocrFront),
      compare: join(compare),
      livenessFace: join(livenessFace),
      livenessCard: join(livenessCard),
      checkMaskedFace: join(checkMaskedFace),
      logSdk: join(logSdk),
      compareGeneral: join(compareGeneral),
      verifyFace: join(verifyFace),
      addFace: join(addFace),
      addCardId: join(addCardId),
      searchFace: join(searchFace),
      livenessFace3D: join(livenessFace3D),
    );
  }

  // 8 field dưới đây có ở cả Android và iOS (constant tồn tại ở cả 2 SDK).
  final String? uploadImage;
  final String? ocr;
  final String? ocrFront;
  final String? compare;
  final String? livenessFace;
  final String? livenessCard;
  final String? checkMaskedFace;
  final String? logSdk;

  // 6 field dưới đây chỉ có hiệu lực trên iOS — bản AAR Android hiện vendor trong plugin chưa
  // có constant tương ứng, truyền vào sẽ bị bỏ qua trên Android.
  final String? compareGeneral;
  final String? verifyFace;
  final String? addFace;
  final String? addCardId;
  final String? searchFace;
  final String? livenessFace3D;

  Map<String, Object?> toMap() => <String, Object?>{
    'uploadImage': uploadImage,
    'ocr': ocr,
    'ocrFront': ocrFront,
    'compare': compare,
    'livenessFace': livenessFace,
    'livenessCard': livenessCard,
    'checkMaskedFace': checkMaskedFace,
    'logSdk': logSdk,
    'compareGeneral': compareGeneral,
    'verifyFace': verifyFace,
    'addFace': addFace,
    'addCardId': addCardId,
    'searchFace': searchFace,
    'livenessFace3D': livenessFace3D,
  }..removeWhere((_, v) => v == null);
}
