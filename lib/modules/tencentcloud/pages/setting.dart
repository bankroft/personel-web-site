import 'package:bk_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final TextEditingController _secretIDController = TextEditingController();
  final TextEditingController _secretKeyController = TextEditingController();
  final TextEditingController _instanceIdController = TextEditingController();

  late SharedPreferences _pref;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      _pref = value;
      reload();
    });
  }

  void reload() {
    _pref.reload();
    setState(() {
      _secretIDController.text =
          _pref.getString(buildSharedPreferenceKey(moduleKey, "SecretID")) ??
              "";
      _secretKeyController.text =
          _pref.getString(buildSharedPreferenceKey(moduleKey, "SecretKey")) ??
              "";
      _instanceIdController.text =
          _pref.getString(buildSharedPreferenceKey(moduleKey, "InstanceId")) ??
              "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _unfocus(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: "SecretID"),
                  controller: _secretIDController,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  decoration: const InputDecoration(labelText: "SecretKey"),
                  controller: _secretKeyController,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  decoration: const InputDecoration(labelText: "InstanceID"),
                  controller: _instanceIdController,
                ),
              ],
            ),
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.save),
          onPressed: () {
            _pref.setString(buildSharedPreferenceKey(moduleKey, "SecretID"),
                _secretIDController.text);
            _pref.setString(buildSharedPreferenceKey(moduleKey, "SecretKey"),
                _secretKeyController.text);
            _pref.setString(buildSharedPreferenceKey(moduleKey, "InstanceId"),
                _instanceIdController.text);
            _unfocus();
          },
        ),
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.reload),
          onPressed: () {
            reload();
            _unfocus();
          },
        ),
      ],
    );
  }
}
