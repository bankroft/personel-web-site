import 'dart:convert';

import 'package:bk_app/main.dart';
import 'package:bk_app/services/global_service.dart';
import 'package:bk_app/services/sharedpreference_service.dart';
import 'package:bk_app/widgets/mdropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final List<Map<String, String>> _languageItems = [];
  final TextEditingController _settingsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    for (final locale in AppLocalizations.supportedLocales) {
      final applocalizations = await AppLocalizations.delegate.load(locale);
      _languageItems.add({
        "key": locale.languageCode,
        "value": applocalizations.language_display_name
      });
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
          TextField(
            decoration: InputDecoration(
                labelText: AppLocalizations.of(
                        GlobalService.navigatorKey.currentState!.context)!
                    .setting),
            controller: _settingsController,
          ),
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
          const SizedBox(height: 8.0),
          _buildLocalSetting(context),
        ],
      ),
    );
  }

  Widget _buildLocalSetting(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(AppLocalizations.of(context)!.language),
        const SizedBox(
          height: 16.0,
          child: VerticalDivider(thickness: 2.0),
        ),
        MDropdownButton(
          hint: AppLocalizations.of(context)!.selectLanguage,
          value: GlobalService.locale.languageCode,
          dropdownItems: _languageItems,
          onChanged: (String? language) {
            if (language == null) {
              return;
            }
            GlobalService.locale = Locale(language);
            RestartWidget.restartApp(context);
          },
        ),
      ],
    );
  }

  void _importSetting() async {
    if (_settingsController.text.isNotEmpty) {
      try {
        Map result = jsonDecode(_settingsController.text);
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
