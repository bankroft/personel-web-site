import 'package:bk_app/modules/tencentcloud/pages/bottom_navigation.dart';
import 'package:flutter/material.dart';

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
