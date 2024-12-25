import 'package:app_usages_plus/app_usage_data.dart';
import 'package:app_usages_plus/app_usages_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<AppUsageData> usages = <AppUsageData>[];

  @override
  void initState() {
    super.initState();
    getUsagesData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Found apps with usage: ${usages.length}'),
        ),
      ),
    );
  }

  void getUsagesData() {
    AppUsagePlugin.getAppUsageStats(DateTime(2024), DateTime.now()).then((value) => setState(() => usages.addAll(value)));
  }
}
