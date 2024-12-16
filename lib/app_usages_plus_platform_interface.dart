import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_usages_plus_method_channel.dart';

abstract class AppUsagesPlatform extends PlatformInterface {
  /// Constructs a AppUsagesPlatform.
  AppUsagesPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppUsagesPlatform _instance = MethodChannelAppUsages();

  /// The default instance of [AppUsagesPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppUsages].
  static AppUsagesPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppUsagesPlatform] when
  /// they register themselves.
  static set instance(AppUsagesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
