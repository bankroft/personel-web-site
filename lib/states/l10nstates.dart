import 'package:bk_app/services/sharedpreference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationsState extends ChangeNotifier {
  LocalizationsState() : _locale = AppLocalizations.supportedLocales.first;

  LocalizationsState.init(BuildContext context) {
    _locale = AppLocalizations.supportedLocales.first;
    SharedPreferenceService().getString("LANGUAGE_CODE").then((value) {
      if (value != null) {
        _locale = Locale(value);
      }
      notifyListeners();
    });
  }
  late Locale _locale;

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = locale;
    SharedPreferenceService().setString("LANGUAGE_CODE", locale.languageCode);
    notifyListeners();
  }
}
