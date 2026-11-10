/// Flow eKYC cần chạy. Mỗi flow tương ứng với một chuỗi màn hình native SDK.
enum VnptEkycFlow {
  /// Chụp giấy tờ mặt trước + sau, chụp chân dung, OCR và các check khuôn mặt.
  full,

  /// Chụp giấy tờ mặt trước + sau và OCR. Hộ chiếu và bằng lái sẽ bỏ qua mặt sau.
  ocr,

  /// Chỉ chụp mặt trước giấy tờ và OCR.
  ocrFront,

  /// Chỉ chụp mặt sau giấy tờ và OCR. Bắt buộc có [VnptEkycConfig.hashFrontOcr].
  ocrBack,

  /// Chụp chân dung, kèm theo check liveness, che mặt, so khớp (tuỳ chọn).
  face,

  /// Quét mã QR trên CCCD gắn chip.
  qrCode,
}

enum VnptDocumentType {
  identityCard,
  identityCardChip,
  passport,
  driverLicense,
  militaryCard,
}

/// Chế độ chụp chân dung.
enum VnptFaceMode {
  /// Chụp một góc duy nhất.
  standard,

  /// Chụp Oval xa/gần kèm quét 3D.
  advanced,
}

enum VnptLanguage { vietnamese, english }

enum VnptLivenessMode {
  none,
  iBeta,

  /// VNPT khuyến cáo không nên dùng.
  standard,
}

/// Các check chất lượng giấy tờ chạy trên client. VNPT mô tả thời điểm kiểm tra chính xác của
/// từng mức (trước hay sau khi chụp) hơi khác nhau giữa Android và iOS.
enum VnptValidateDocument { none, basic, medium, advance }

enum VnptFaceOvalMode { farAndNear, farOnly, nearOnly }

enum VnptCameraPosition { front, back }

/// Loại hình giao dịch báo cáo với VNPT: khách hàng mới, khách hàng cũ, xác thực lại.
enum VnptBusinessFlow { ntb, etb, verify }

enum VnptBlockedDocument {
  identityCard9,
  identityCard12,
  citizenIdCard,
  passport,
  militaryCard,
  driverLicense,
  citizenIdChip,
  citizenIdChip01072024,
}
