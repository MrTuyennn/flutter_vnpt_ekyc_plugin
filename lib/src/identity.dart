import 'json_envelope.dart';

/// `tampering.is_legal` has been observed as both a real JSON boolean
/// (`true`/`false`) and the string `"yes"`/`"no"` depending on VNPT's
/// service version — this accepts either instead of assuming one shape.
/// `null` (unknown) for anything else, rather than silently defaulting to
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

/// Personal data read from an ID document by OCR (or from its QR code).
///
/// Built from the VNPT service JSON; the field names follow the SDK models
/// (`IdentityCard`, `Passport`, `DriverLicense`, `QRCode`). Fields absent for the
/// scanned document type are null. This is personal data: do not log it.
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

  /// Parses the `ocrResult` or `qrCodeResult` JSON string. Returns null when it
  /// is missing or not a JSON object.
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

  /// Citizen ID / ID card number.
  final String? id;
  final String? name;

  /// Kept as printed on the document (`dd/MM/yyyy`).
  final String? birthDay;
  final String? gender;
  final String? nationality;
  final String? cardType;

  /// VNPT document type id.
  final String? typeId;
  final String? issueDate;
  final String? issuePlace;
  final String? validDate;
  final String? originLocation;
  final String? recentLocation;

  /// Passport only.
  final String? passportNo;
  final String? citizenId;
  final String? codeNumber;
  final String? birthPlace;

  /// Driver license only.
  final String? rank;

  final String? expireWarning;
  final List<String> warnings;

  /// Tampering check of the document image; null if the service did not report it.
  final bool? isLegal;

  /// Every field of the JSON, for fields not modelled above (e.g. post codes).
  final Map<String, Object?> raw;

  /// The typed fields above as a flat, JSON-encodable map (absent fields omitted).
  /// Use [raw] instead for the untouched OCR/QR JSON.
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
