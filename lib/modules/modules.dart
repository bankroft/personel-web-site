import 'package:bk_app/services/global_service.dart';

import '/modules/tencentcloud/main.dart' as tencentcloud_main;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'base.dart';

// icon size: 24
// icon color: 33, 150, 243; #2196F3
Map<String, ModuleDefs> allmodulesMap = {};

// to list
List<ModuleDefs> allmodulesList = [];

void initModules() {
  allmodulesMap = {
    '/modules/${tencentcloud_main.Main.name}': ModuleDefs(
      route: '/modules/${tencentcloud_main.Main.name}',
      func: (context) => const tencentcloud_main.Main(),
      icon: 'assets/modules/tencentcloud/qq-line.png',
      name: () =>
          AppLocalizations.of(GlobalService.navigatorKey.currentState!.context)!
              .modules_tencentcloud_name,
      description: () =>
          AppLocalizations.of(GlobalService.navigatorKey.currentState!.context)!
              .modules_tencentcloud_desp,
    ),
  };
  allmodulesList = allmodulesMap.values.toList();
}
