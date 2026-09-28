import 'src/config.dart';
import 'src/enums.dart';
import 'src/platform_interface.dart';
import 'src/result.dart';

export 'src/checks.dart';
export 'src/config.dart';
export 'src/enums.dart';
export 'src/identity.dart';
export 'src/result.dart';

/// Entry point to the VNPT eKYC native SDKs.
class VnptEkyc {
  const VnptEkyc._();

  /// Opens the native SDK for [flow] and completes when it closes.
  ///
  /// Returns [VnptEkycStatus.cancelled] if the user backs out. Throws a
  /// `PlatformException` with one of these codes: `no_activity`,
  /// `already_running`, `camera_permission_denied`, `invalid_argument`, `sdk_error`.
  static Future<VnptEkycResult> start(
    VnptEkycFlow flow,
    VnptEkycConfig config,
  ) => VnptEkycPlatform.instance.start(flow, config);
}
