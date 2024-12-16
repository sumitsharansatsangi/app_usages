import 'package:flutter_test/flutter_test.dart';
import 'package:app_usages_plus/app_usages_plus.dart';
import 'package:app_usages_plus/app_usages_plus_platform_interface.dart';
import 'package:app_usages_plus/app_usages_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppUsagesPlatform
    with MockPlatformInterfaceMixin
    implements AppUsagesPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppUsagesPlatform initialPlatform = AppUsagesPlatform.instance;

  test('$MethodChannelAppUsages is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppUsages>());
  });

  test('getPlatformVersion', () async {
    final usages = await AppUsagePlugin.getAppUsageStats(DateTime(2024), DateTime.now());
    expect(usages.isNotEmpty, true);
  });
}
