import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationsState extends ChangeNotifier {
  Locale _locale = AppLocalizations.supportedLocales.first;

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
