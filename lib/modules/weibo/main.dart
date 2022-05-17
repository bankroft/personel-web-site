import 'package:flutter/material.dart';

import '../base.dart';
import 'config.dart';
import 'pages/hot_search.dart';

class Main extends BaseModule {
  static get name {
    return moduleKey;
  }

  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HotSearch();
  }
}
