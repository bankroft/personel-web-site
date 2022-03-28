import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../base.dart';
import 'config.dart';

class Main extends BaseModule {
  static get name {
    return moduleKey;
  }

  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.modules_qrcode_name),
      ),
      body: const Center(
        child: Text('TODO'),
      ),
    );
  }
}
