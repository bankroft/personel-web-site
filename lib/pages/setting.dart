import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
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
        ],
      ),
    );
  }

  void _importSetting() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      try {
        Map result = jsonDecode(data.text!);
        SharedPreferences.getInstance().then((prefs) {
          result.forEach((key, value) {
            prefs.setString(key, value);
          });
          MotionToast.success(
            title: Text(AppLocalizations.of(context)!.importSetting),
            description: Text(AppLocalizations.of(context)!.success),
          ).show(context);
        });
      } catch (e) {
        MotionToast.error(
          title: Text(AppLocalizations.of(context)!.importSetting),
          description: Text(AppLocalizations.of(context)!.fail),
        ).show(context);
      }
    }
  }

  void _exportSetting() {
    SharedPreferences.getInstance().then((prefs) {
      Map data = {};
      for (var item in prefs.getKeys()) {
        data[item] = prefs.get(item);
      }
      Clipboard.setData(ClipboardData(text: jsonEncode(data))).then(
        (value) => MotionToast.success(
          title: Text(AppLocalizations.of(context)!.exportSetting),
          description: Text(AppLocalizations.of(context)!.success),
        ).show(context),
      );
    });
  }

  void _deleteSetting() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear().then((value) {
        if (value) {
          MotionToast.delete(
            title: Text(AppLocalizations.of(context)!.deleteSetting),
            description: Text(AppLocalizations.of(context)!.success),
          ).show(context);
        } else {
          MotionToast.error(
            title: Text(AppLocalizations.of(context)!.deleteSetting),
            description: Text(AppLocalizations.of(context)!.fail),
          ).show(context);
        }
      });
    });
  }
}
