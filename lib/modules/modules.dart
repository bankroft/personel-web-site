import 'package:bk_app/services/global_service.dart';

import '/modules/tencentcloud/main.dart' as tencentcloud_main;
import '/modules/qrcode/main.dart' as qrcode_main;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'base.dart';

final Map<String, ModuleDefs> allmodulesMap = {
  '/modules/${tencentcloud_main.Main.name}': ModuleDefs(
    route: '/modules/${tencentcloud_main.Main.name}',
    func: (context) => const tencentcloud_main.Main(),
    icon: 'assets/modules/tencentcloud/logo.png',
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
    icon: 'assets/modules/qrcode/qr-scan-2-fill.png',
    name: () =>
        AppLocalizations.of(GlobalService.navigatorKey.currentState!.context)!
            .modules_qrcode_name,
    description: () =>
        AppLocalizations.of(GlobalService.navigatorKey.currentState!.context)!
            .modules_qrcode_desp,
  ),
};

// to list
final List<ModuleDefs> allmodulesList = allmodulesMap.values.toList();
