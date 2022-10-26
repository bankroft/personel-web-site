import 'dart:convert';

import 'package:bk_app/services/sharedpreference_service.dart';
import 'package:bk_app/states/l10nstates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final List<DropdownMenuItem<Locale>> _languageItems = [];
  late final l10nState =
      Provider.of<LocalizationsState>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    for (final locale in AppLocalizations.supportedLocales) {
      final applocalizations = await AppLocalizations.delegate.load(locale);
      _languageItems.add(
        DropdownMenuItem(
            child: Text(applocalizations.language_display_name), value: locale),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => _importSetting(),
            icon: const Icon(Icons.archive_outlined),
            label: Text(AppLocalizations.of(context)!.importSetting),
          ),
          ElevatedButton.icon(
            onPressed: () => _exportSetting(),
            icon: const Icon(Icons.unarchive_outlined),
            label: Text(AppLocalizations.of(context)!.exportSetting),
          ),
          ElevatedButton.icon(
            onPressed: () => _deleteSetting(),
            icon: const Icon(Icons.delete_outlined),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return Colors.red;
              }),
            ),
            label: Text(AppLocalizations.of(context)!.deleteSetting),
          ),
          const Divider(),
          _buildLocalSetting(context),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildLocalSetting(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(AppLocalizations.of(context)!.language),
        DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: l10nState.locale,
            items: _languageItems,
            onChanged: (Locale? locale) {
              if (locale == null) {
                return;
              }
              l10nState.locale = locale;
            },
          ),
        ),
      ],
    );
  }

  void _importSetting() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      try {
        Map result = jsonDecode(data.text!);
        SharedPreferenceService().prefs.then((prefs) {
          result.forEach((key, value) {
            prefs.setString(key, value);
          });
          EasyLoading.showToast(
              "${AppLocalizations.of(context)!.importSetting}: ${AppLocalizations.of(context)!.success}");
        });
      } catch (e) {
        EasyLoading.showToast(
            "${AppLocalizations.of(context)!.importSetting}: ${AppLocalizations.of(context)!.fail}");
      }
    }
  }

  void _exportSetting() {
    SharedPreferenceService().prefs.then((prefs) {
      Map data = {};
      for (var item in prefs.getKeys()) {
        data[item] = prefs.get(item);
      }
      Clipboard.setData(ClipboardData(text: jsonEncode(data))).then(
        (value) => EasyLoading.showToast(
            "${AppLocalizations.of(context)!.exportSetting}: ${AppLocalizations.of(context)!.success}"),
      );
    });
  }

  void _deleteSetting() {
    SharedPreferenceService().prefs.then((value) {
      value.clear();
      EasyLoading.showToast(
          "${AppLocalizations.of(context)!.deleteSetting}: ${AppLocalizations.of(context)!.success}");
    });
  }
}
