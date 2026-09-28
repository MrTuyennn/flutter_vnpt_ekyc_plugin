import 'package:flutter/services.dart';

import 'config.dart';
import 'enums.dart';
import 'platform_interface.dart';
import 'result.dart';

class MethodChannelVnptEkyc extends VnptEkycPlatform {
  static const MethodChannel channel = MethodChannel(
    'flutter_vnpt_ekyc_plugin',
  );

  @override
  Future<VnptEkycResult> start(VnptEkycFlow flow, VnptEkycConfig config) async {
    final response = await channel.invokeMapMethod<Object?, Object?>(
      'start',
      <String, Object?>{'flow': flow.name, 'config': config.toMap()},
    );
    if (response == null) {
      throw PlatformException(
        code: 'sdk_error',
        message: 'The native SDK returned no result.',
      );
    }
    return VnptEkycResult.fromMap(response);
  }
}
