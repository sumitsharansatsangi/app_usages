import 'package:flutter_test/flutter_test.dart';
import 'package:app_usages/app_usages.dart';
import 'package:app_usages/app_usages_platform_interface.dart';
import 'package:app_usages/app_usages_method_channel.dart';
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
    AppUsages appUsagesPlugin = AppUsages();
    MockAppUsagesPlatform fakePlatform = MockAppUsagesPlatform();
    AppUsagesPlatform.instance = fakePlatform;

    expect(await appUsagesPlugin.getPlatformVersion(), '42');
  });
}
