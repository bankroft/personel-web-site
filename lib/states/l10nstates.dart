import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationsState extends ChangeNotifier {
  LocalizationsState() : _locale = AppLocalizations.supportedLocales.first;

  LocalizationsState.init(BuildContext context) {
    _locale = Locale(Platform.localeName.split("_")[0]);
  }
  late Locale _locale;

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
