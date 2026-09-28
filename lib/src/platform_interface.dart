import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'config.dart';
import 'enums.dart';
import 'method_channel.dart';
import 'result.dart';

abstract class VnptEkycPlatform extends PlatformInterface {
  VnptEkycPlatform() : super(token: _token);

  static final Object _token = Object();

  static VnptEkycPlatform _instance = MethodChannelVnptEkyc();

  static VnptEkycPlatform get instance => _instance;

  static set instance(VnptEkycPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<VnptEkycResult> start(VnptEkycFlow flow, VnptEkycConfig config) {
    throw UnimplementedError('start() has not been implemented.');
  }
}
