import 'package:bk_app/services/global_service.dart';

import '/modules/tencentcloud/main.dart' as tencentcloud_main;
import '/modules/qrcode/main.dart' as qrcode_main;
import '/modules/weibo/main.dart' as weibo_main;
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
    '/modules/${qrcode_main.Main.name}': ModuleDefs(
      route: '/modules/${qrcode_main.Main.name}',
      func: (context) => const qrcode_main.Main(),
      icon: 'assets/modules/qrcode/qr-code-line.png',
      name: () =>
          AppLocalizations.of(GlobalService.navigatorKey.currentState!.context)!
              .modules_qrcode_name,
      description: () =>
          AppLocalizations.of(GlobalService.navigatorKey.currentState!.context)!
              .modules_qrcode_desp,
    ),
    '/modules/${weibo_main.Main.name}': ModuleDefs(
      route: '/modules/${weibo_main.Main.name}',
      func: (context) => const weibo_main.Main(),
      icon: 'assets/modules/weibo/weibo-fill.png',
      name: () =>
          AppLocalizations.of(GlobalService.navigatorKey.currentState!.context)!
              .modules_weibo_name,
      description: () =>
          AppLocalizations.of(GlobalService.navigatorKey.currentState!.context)!
              .modules_weibo_desp,
    ),
  };
  allmodulesList = allmodulesMap.values.toList();
}
