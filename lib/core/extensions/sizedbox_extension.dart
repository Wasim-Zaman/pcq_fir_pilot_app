library;

import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  /// Extension method to create a vertical SizedBox with height equal to the number
  Widget get heightBox => SizedBox(height: toDouble());

  /// Extension method to create a horizontal SizedBox with width equal to the number
  Widget get widthBox => SizedBox(width: toDouble());
}
