import 'package:flutter/material.dart';

import '/modules/qrcode/pages/bottom_navigation.dart';
import '../base.dart';
import 'config.dart';

class Main extends BaseModule {
  static get name {
    return moduleKey;
  }

  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BottomNavigation();
  }
}