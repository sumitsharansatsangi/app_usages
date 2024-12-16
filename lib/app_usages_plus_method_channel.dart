import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_usages_plus_platform_interface.dart';

/// An implementation of [AppUsagesPlatform] that uses method channels.
class MethodChannelAppUsages extends AppUsagesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_usages_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
