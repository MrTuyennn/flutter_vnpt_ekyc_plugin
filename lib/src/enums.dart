/// eKYC flow to launch. Each flow maps to one native SDK screen sequence.
enum VnptEkycFlow {
  /// Front + back document capture, portrait capture, OCR and face checks.
  full,

  /// Front + back document capture and OCR. Passport and driver license skip the back side.
  ocr,

  /// Front side document capture and OCR only.
  ocrFront,

  /// Back side document capture and OCR only. Requires [VnptEkycConfig.hashFrontOcr].
  ocrBack,

  /// Portrait capture with optional liveness, mask and compare checks.
  face,

  /// QR code scan on a chip-based citizen ID.
  qrCode,
}

enum VnptDocumentType {
  identityCard,
  identityCardChip,
  passport,
  driverLicense,
  militaryCard,
}

/// Portrait capture mode.
enum VnptFaceMode {
  /// Single-angle capture.
  standard,

  /// Oval far/near capture with 3D scan.
  advanced,
}

enum VnptLanguage { vietnamese, english }

enum VnptLivenessMode {
  none,
  iBeta,

  /// Not recommended by VNPT.
  standard,
}

/// Client-side document checks. VNPT describes the exact timing of each level
/// (before or after capture) slightly differently on Android and iOS.
enum VnptValidateDocument { none, basic, medium, advance }

enum VnptFaceOvalMode { farAndNear, farOnly, nearOnly }

enum VnptCameraPosition { front, back }

/// Business flow reported to VNPT: new-to-bank, existing-to-bank, verify.
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
