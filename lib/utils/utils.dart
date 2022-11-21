import 'package:flutter/material.dart';

String buildSharedPreferenceKey(String moduleKey, String key) {
  return "$moduleKey.$key";
}

List mergeList(List a, List b, {dynamic Function()? valid}) {
  if (valid != null) {
    return [];
  } else {
    return [...a, ...b];
  }
}

Map<int, Color> getPrimarySwatch(Color color) {
  return {
    50: color,
    100: color,
    200: color,
    300: color,
    400: color,
    500: color,
    600: color,
    700: color,
    800: color,
    900: color,
  };
}
