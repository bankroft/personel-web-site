import 'package:flutter/material.dart';

class GlobalService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalService _singleton = GlobalService._();

  factory GlobalService() {
    return _singleton;
  }

  GlobalService._();
}
