import 'dart:typed_data';

/// Vị trí nút đóng trên thanh tiêu đề của màn hình native SDK.
enum VnptHeaderButtonPosition { left, right }

class VnptEkycImage {
  const VnptEkycImage({this.bytes, this.androidDrawableName});

  final Uint8List? bytes;
  final String? androidDrawableName;

  Map<String, Object?> toMap() => <String, Object?>{
    'bytes': bytes,
    'androidDrawableName': androidDrawableName,
  }..removeWhere((_, v) => v == null);
}

class VnptEkycTheme {
  const VnptEkycTheme({
    this.headerContentColor,
    this.headerBackgroundColor,
    this.mainContentColor,
    this.mainTitleColor,
    this.mainBackgroundColor,
    this.lineColor,
    this.activeButtonBackgroundColor,
    this.activeButtonTitleColor,
    this.inactiveButtonBackgroundColor,
    this.inactiveButtonTitleColor,
    this.documentCaptureBackgroundColor,
    this.faceCaptureBackgroundColor,
    this.faceNoticeEffectColor,
    this.faceNoticeTextColor,
    this.validDocumentEffectColor,
    this.validDocumentTextColor,
    this.invalidDocumentEffectColor,
    this.invalidDocumentTextColor,
    this.captureButtonTintColor,
    this.faceBorderColor,
    this.popupBackgroundColor,
    this.popupTextColor,
    this.headerButtonPosition,
    this.logo,
    this.logoWidth,
    this.logoHeight,
    this.logoFaceOval,
    this.logoFaceOvalWidth,
    this.logoFaceOvalHeight,
    this.showLogo,
    this.tutorialQrCodeImage,
    this.tutorialFrontImage,
    this.tutorialBackImage,
    this.tutorialBlurImage,
    this.tutorialGlareImage,
    this.tutorialLostAngleImage,
    this.loadingEffectColor,
    this.loadingBackgroundColor,
    this.flashBackgroundColor,
    this.flashTitleColor,
    this.headerBarCornerRadius,
    this.buttonCornerRadius,
  });

  final int? headerContentColor;
  final int? headerBackgroundColor;
  final int? mainContentColor;
  final int? mainTitleColor;
  final int? mainBackgroundColor;
  final int? lineColor;
  final int? activeButtonBackgroundColor;
  final int? activeButtonTitleColor;
  final int? inactiveButtonBackgroundColor;
  final int? inactiveButtonTitleColor;
  final int? documentCaptureBackgroundColor;
  final int? faceCaptureBackgroundColor;
  final int? faceNoticeEffectColor;
  final int? faceNoticeTextColor;
  final int? validDocumentEffectColor;
  final int? validDocumentTextColor;
  final int? invalidDocumentEffectColor;
  final int? invalidDocumentTextColor;
  final int? captureButtonTintColor;
  final int? faceBorderColor;
  final int? popupBackgroundColor;
  final int? popupTextColor;

  final VnptHeaderButtonPosition? headerButtonPosition;

  /// Logo thương hiệu hiển thị cuối mỗi màn hình. Mặc định "Powered by VNPT AI".
  final VnptEkycImage? logo;
  final double? logoWidth;
  final double? logoHeight;

  /// Logo hiển thị ở màn chụp Oval. Mặc định "VNPT AI".
  final VnptEkycImage? logoFaceOval;

  /// Chỉ có hiệu lực trên Android — SDK iOS không có kích thước riêng cho logo này.
  final double? logoFaceOvalWidth;
  final double? logoFaceOvalHeight;

  /// Ẩn/hiện logo. Mặc định true (hiện). Chỉ có hiệu lực trên Android.
  final bool? showLogo;

  final VnptEkycImage? tutorialQrCodeImage;
  final VnptEkycImage? tutorialFrontImage;
  final VnptEkycImage? tutorialBackImage;
  final VnptEkycImage? tutorialBlurImage;
  final VnptEkycImage? tutorialGlareImage;
  final VnptEkycImage? tutorialLostAngleImage;

  /// Chỉ có hiệu lực trên Android.
  final int? loadingEffectColor;
  final int? loadingBackgroundColor;

  /// Chỉ có hiệu lực trên iOS.
  final int? flashBackgroundColor;
  final int? flashTitleColor;

  /// Chỉ có hiệu lực trên Android. Đơn vị logical pixel (giống các giá trị `double` khác trong
  /// Flutter); plugin tự quy đổi sang pixel thực theo density của thiết bị trước khi gửi xuống
  /// SDK, vì bản thân SDK native nhận trực tiếp bán kính theo pixel thực.
  final double? headerBarCornerRadius;
  final double? buttonCornerRadius;

  Map<String, Object?> toMap() => <String, Object?>{
    'headerContentColor': headerContentColor,
    'headerBackgroundColor': headerBackgroundColor,
    'mainContentColor': mainContentColor,
    'mainTitleColor': mainTitleColor,
    'mainBackgroundColor': mainBackgroundColor,
    'lineColor': lineColor,
    'activeButtonBackgroundColor': activeButtonBackgroundColor,
    'activeButtonTitleColor': activeButtonTitleColor,
    'inactiveButtonBackgroundColor': inactiveButtonBackgroundColor,
    'inactiveButtonTitleColor': inactiveButtonTitleColor,
    'documentCaptureBackgroundColor': documentCaptureBackgroundColor,
    'faceCaptureBackgroundColor': faceCaptureBackgroundColor,
    'faceNoticeEffectColor': faceNoticeEffectColor,
    'faceNoticeTextColor': faceNoticeTextColor,
    'validDocumentEffectColor': validDocumentEffectColor,
    'validDocumentTextColor': validDocumentTextColor,
    'invalidDocumentEffectColor': invalidDocumentEffectColor,
    'invalidDocumentTextColor': invalidDocumentTextColor,
    'captureButtonTintColor': captureButtonTintColor,
    'faceBorderColor': faceBorderColor,
    'popupBackgroundColor': popupBackgroundColor,
    'popupTextColor': popupTextColor,
    'headerButtonPosition': headerButtonPosition?.name,
    'logo': logo?.toMap(),
    'logoWidth': logoWidth,
    'logoHeight': logoHeight,
    'logoFaceOval': logoFaceOval?.toMap(),
    'logoFaceOvalWidth': logoFaceOvalWidth,
    'logoFaceOvalHeight': logoFaceOvalHeight,
    'showLogo': showLogo,
    'tutorialQrCodeImage': tutorialQrCodeImage?.toMap(),
    'tutorialFrontImage': tutorialFrontImage?.toMap(),
    'tutorialBackImage': tutorialBackImage?.toMap(),
    'tutorialBlurImage': tutorialBlurImage?.toMap(),
    'tutorialGlareImage': tutorialGlareImage?.toMap(),
    'tutorialLostAngleImage': tutorialLostAngleImage?.toMap(),
    'loadingEffectColor': loadingEffectColor,
    'loadingBackgroundColor': loadingBackgroundColor,
    'flashBackgroundColor': flashBackgroundColor,
    'flashTitleColor': flashTitleColor,
    'headerBarCornerRadius': headerBarCornerRadius,
    'buttonCornerRadius': buttonCornerRadius,
  }..removeWhere((_, v) => v == null);
}
