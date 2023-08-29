import 'package:flutter/material.dart';

extension PercentSize on Size{
  double percent(
      double per,
      Percent type,
      ) {
    if (type == Percent.width) {
      return ((width * per) / 100);
    }

    if (type == Percent.height) {
      return ((height * per) / 100);
    }
    return 0;
  }
}

enum Percent { width, height }