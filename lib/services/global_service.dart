import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'sharedpreference_service.dart';

class GlobalService {
  static final GlobalService _singleton = GlobalService._();
  factory GlobalService() {
    return _singleton;
  }
  GlobalService._();

  static Future<void> init() async {
    final value = await SharedPreferenceService().getString("LANGUAGE_CODE");
    if (value != null) {
      _locale = Locale(value);
    }
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Locale _locale = AppLocalizations.supportedLocales.first;
  static Locale get locale => _locale;
  static set locale(Locale locale) {
    _locale = locale;
    SharedPreferenceService().setString("LANGUAGE_CODE", locale.languageCode);
  }
}
