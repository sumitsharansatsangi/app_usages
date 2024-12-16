import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_usages_plus_platform_interface.dart';

class MethodChannelAppUsages extends AppUsagesPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('app_usages_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
