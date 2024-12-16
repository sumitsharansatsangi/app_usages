import 'package:flutter/services.dart';

class AppUsagePlugin {
  static const MethodChannel _channel = MethodChannel('app_usages_plus');

  static Future<List<Map<String, dynamic>>> getAppUsageStats(DateTime startDate, DateTime endDate, {List<String>? packageNames}) async {
    final result = await _channel.invokeMethod('getAppUsageStats', {
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'packageNames': packageNames, // Pass the package names to the native side
    });
    return List<Map<String, dynamic>>.from(result.map((e) => (e as Map).cast<String, dynamic>()));
  }

  static Future<void> openUsageAccessSettings() async {
    await _channel.invokeMethod('openUsageAccessSettings');
  }
}
