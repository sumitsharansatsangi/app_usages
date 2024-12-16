import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class AppUsageData {
  String? packageName;
  String? appLabel;
  DateTime? installTime;
  String? icon; // Base64 String representation
  Uint8List? memoryIcon; // Decoded Uint8List from Base64
  List<Usages>? usages;

  AppUsageData({
    this.packageName,
    this.appLabel,
    this.installTime,
    this.icon,
    this.usages,
  }) {
    // Decode Base64 icon to Uint8List if available
    if (icon != null) {
      memoryIcon = base64Decode(icon!);
    }
  }

  /// A getter to build and return the app icon as a Widget.
  Widget get iconWidget {
    return buildAppIcon();
  }

  /// Calculate total usage time in foreground.
  int get totalUsage {
    var usage = 0;
    usages?.forEach(
          (element) => usage += (element.totalTimeInForeground ?? 0),
    );
    return usage;
  }

  /// Constructor to initialize the object from a JSON map.
  AppUsageData.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
    appLabel = json['appLabel'];
    icon = json['icon']; // Base64 string from JSON
    if (icon != null) {
      memoryIcon = base64Decode(icon!); // Decode Base64 to Uint8List
    }
    installTime = DateTime.fromMillisecondsSinceEpoch(json['installTime']);
    if (json['usages'] != null) {
      usages = <Usages>[];
      json['usages'].forEach((v) {
        usages!.add(Usages.fromJson(v.cast<String, dynamic>()));
      });
    }
  }

  /// Convert the object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packageName'] = packageName;
    data['appLabel'] = appLabel;
    data['installTime'] = installTime?.millisecondsSinceEpoch;
    data['icon'] = icon; // Base64 String
    if (usages != null) {
      data['usages'] = usages!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// Helper to build an app icon Widget from the memoryIcon.
  Widget buildAppIcon({double size = 40}) {
    if (memoryIcon != null && memoryIcon!.isNotEmpty) {
      return Image.memory(
        memoryIcon!,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else {
      return Icon(
        Icons.apps,
        size: size,
      );
    }
  }
}

class Usages {
  int? totalTimeInForeground;
  int? date;

  Usages({
    this.totalTimeInForeground,
    this.date,
  });

  /// Constructor to initialize the object from a JSON map.
  Usages.fromJson(Map<String, dynamic> json) {
    totalTimeInForeground = json['totalTimeInForeground'];
    date = json['date'];
  }

  /// Convert the object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTimeInForeground'] = totalTimeInForeground;
    data['date'] = date;
    return data;
  }
}
