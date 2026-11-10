import 'json_envelope.dart';

/// `tampering.is_legal` được quan sát thấy có khi là boolean JSON thật
/// (`true`/`false`), có khi là chuỗi `"yes"`/`"no"` tuỳ phiên bản service của VNPT
/// — hàm này chấp nhận cả 2 dạng thay vì giả định chỉ một kiểu. Trả về `null`
/// (không xác định) cho mọi trường hợp khác, thay vì âm thầm mặc định thành
/// `false`.
bool? _parseIsLegal(Object? raw) {
  if (raw is bool) return raw;
  if (raw is String) {
    switch (raw.trim().toLowerCase()) {
      case 'yes':
      case 'true':
        return true;
      case 'no':
      case 'false':
        return false;
    }
  }
  return null;
}

/// Dữ liệu cá nhân đọc được từ giấy tờ qua OCR (hoặc từ mã QR của giấy tờ).
///
/// Được dựng từ JSON của service VNPT; tên field theo đúng model của SDK
/// (`IdentityCard`, `Passport`, `DriverLicense`, `QRCode`). Field không có ở loại giấy tờ
/// đang quét sẽ là null. Đây là dữ liệu cá nhân: không log ra ngoài.
class VnptIdentity {
  const VnptIdentity({
    this.id,
    this.name,
    this.birthDay,
    this.gender,
    this.nationality,
    this.cardType,
    this.typeId,
    this.issueDate,
    this.issuePlace,
    this.validDate,
    this.originLocation,
    this.recentLocation,
    this.passportNo,
    this.citizenId,
    this.codeNumber,
    this.birthPlace,
    this.rank,
    this.expireWarning,
    this.warnings = const <String>[],
    this.isLegal,
    this.raw = const <String, Object?>{},
  });

  /// Parse chuỗi JSON `ocrResult` hoặc `qrCodeResult`. Trả về null nếu thiếu
  /// hoặc không phải một JSON object.
  static VnptIdentity? tryParse(String? json) {
    final data = unwrapVnptJson(json);
    if (data == null) return null;

    String? s(String key) => stringField(data, key);

    final tampering = data['tampering'];
    final warnings = data['warning_msg'];
    final isLegalRaw = tampering is Map ? tampering['is_legal'] : null;
    return VnptIdentity(
      id: s('id'),
      name: s('name'),
      birthDay: s('birth_day'),
      gender: s('gender'),
      nationality: s('nationality'),
      cardType: s('card_type'),
      typeId: s('type_id'),
      issueDate: s('issue_date'),
      issuePlace: s('issue_place'),
      validDate: s('valid_date') ?? s('expired_date'),
      originLocation: s('origin_location'),
      recentLocation: s('recent_location'),
      passportNo: s('passport_no'),
      citizenId: s('citizen_id'),
      codeNumber: s('code_number'),
      birthPlace: s('birth_place'),
      rank: s('rank'),
      expireWarning: s('expire_warning'),
      warnings: warnings is List
          ? warnings.whereType<String>().toList(growable: false)
          : const <String>[],
      isLegal: _parseIsLegal(isLegalRaw),
      raw: Map<String, Object?>.unmodifiable(data),
    );
  }

  /// Số CCCD / CMND.
  final String? id;
  final String? name;

  /// Giữ nguyên như in trên giấy tờ (`dd/MM/yyyy`).
  final String? birthDay;
  final String? gender;
  final String? nationality;
  final String? cardType;

  /// Mã loại giấy tờ theo quy ước của VNPT.
  final String? typeId;
  final String? issueDate;
  final String? issuePlace;
  final String? validDate;
  final String? originLocation;
  final String? recentLocation;

  /// Chỉ có ở hộ chiếu.
  final String? passportNo;
  final String? citizenId;
  final String? codeNumber;
  final String? birthPlace;

  /// Chỉ có ở bằng lái xe.
  final String? rank;

  final String? expireWarning;
  final List<String> warnings;

  /// Kết quả check làm giả ảnh giấy tờ; null nếu service không trả về thông tin này.
  final bool? isLegal;

  /// Toàn bộ field của JSON, bao gồm cả những field chưa được model hoá ở trên
  /// (ví dụ mã bưu chính).
  final Map<String, Object?> raw;

  /// Các field đã định kiểu ở trên, gộp thành map phẳng có thể encode JSON (field nào
  /// không có sẽ bị bỏ qua). Dùng [raw] nếu cần JSON OCR/QR gốc, chưa qua xử lý.
  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'birthDay': birthDay,
    'gender': gender,
    'nationality': nationality,
    'cardType': cardType,
    'typeId': typeId,
    'issueDate': issueDate,
    'issuePlace': issuePlace,
    'validDate': validDate,
    'originLocation': originLocation,
    'recentLocation': recentLocation,
    'passportNo': passportNo,
    'citizenId': citizenId,
    'codeNumber': codeNumber,
    'birthPlace': birthPlace,
    'rank': rank,
    'expireWarning': expireWarning,
    'isLegal': isLegal,
    if (warnings.isNotEmpty) 'warnings': warnings,
  }..removeWhere((_, v) => v == null);
}
