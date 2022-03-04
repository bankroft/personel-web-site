import 'package:bk_app/services/sharedpreference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationsState extends ChangeNotifier {
  LocalizationsState() : _locale = AppLocalizations.supportedLocales.first;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final value = await SharedPreferenceService().getString("LANGUAGE_CODE");
    if (value != null) {
      _locale = Locale(value);
    }
    _initialized = true;
  }

  late Locale _locale;

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = locale;
    SharedPreferenceService().setString("LANGUAGE_CODE", locale.languageCode);
    notifyListeners();
  }
}
