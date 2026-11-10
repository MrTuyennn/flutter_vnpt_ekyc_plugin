import 'src/config.dart';
import 'src/enums.dart';
import 'src/platform_interface.dart';
import 'src/result.dart';

export 'src/checks.dart';
export 'src/config.dart';
export 'src/enums.dart';
export 'src/identity.dart';
export 'src/result.dart';

/// Điểm khởi đầu để gọi vào native SDK VNPT eKYC.
class VnptEkyc {
  const VnptEkyc._();

  /// Mở native SDK cho [flow] và hoàn tất khi màn hình đó đóng lại.
  ///
  /// Trả về [VnptEkycStatus.cancelled] nếu người dùng thoát giữa chừng. Ném ra
  /// `PlatformException` với một trong các code: `no_activity`,
  /// `already_running`, `camera_permission_denied`, `invalid_argument`, `sdk_error`,
  /// `activity_detached` (chỉ Android).
  static Future<VnptEkycResult> start(
    VnptEkycFlow flow,
    VnptEkycConfig config,
  ) => VnptEkycPlatform.instance.start(flow, config);
}
