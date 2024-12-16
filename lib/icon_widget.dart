import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget buildAppIcon(String base64Icon, {double size = 40}) {
  if (base64Icon.isEmpty) return Icon(Icons.apps);

  Uint8List bytes = base64Decode(base64Icon);
  return Image.memory(bytes, width: size, height: size);
}
