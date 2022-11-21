import 'dart:convert';

import 'package:bk_app/widgets/empty.dart';
import 'package:bk_app/widgets/mcard.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../utils/constants.dart';
import '../widgets/add.dart';

import '../models/apiresponse.dart';
import '../models/common.dart';
import '../models/portmanager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config.dart';
import '../services/api_service.dart';
import 'package:bk_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences prefs;
  late bool configured = false;
  final PortManager _portManager = PortManager();

  late String _instanceId;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      if (prefs.containsKey(buildSharedPreferenceKey(moduleKey, "SecretID")) &&
          prefs.containsKey(buildSharedPreferenceKey(moduleKey, "SecretKey")) &&
          prefs
              .containsKey(buildSharedPreferenceKey(moduleKey, "InstanceId"))) {
        ApiService().reset(
            secretID: prefs
                .getString(buildSharedPreferenceKey(moduleKey, "SecretID"))!,
            secretKey: prefs
                .getString(buildSharedPreferenceKey(moduleKey, "SecretKey"))!);

        _instanceId =
            prefs.getString(buildSharedPreferenceKey(moduleKey, "InstanceId"))!;
        configured = true;
        _reload();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _reload() async {
    PortManager().clear();
    setState(() {});
    if (!configured) {
      return;
    }
    if (prefs.containsKey(
        buildSharedPreferenceKey(moduleKey, "CachePorts-$_instanceId"))) {
      final cachePorts = prefs.getString(
          buildSharedPreferenceKey(moduleKey, "CachePorts-$_instanceId"))!;
      final data = jsonDecode(cachePorts) as Map<String, dynamic>;
      for (var element in data["ports"] as List<dynamic>) {
        final port = Port.fromJson(element);
        _portManager.addOrUpdate(port);
      }
      setState(() {});
    }
    await _reloadFromNet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Add(
                    onClick: (port) {
                      _open(port);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _reload();
        },
        child: _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    return _portManager.count > 0
        ? ReorderableListView.builder(
            padding: const EdgeInsets.only(top: 8.0),
            proxyDecorator:
                (Widget child, int index, Animation<double> animation) {
              return child;
            },
            itemBuilder: (_, index) {
              return MCard(
                key: Key("Card_${_portManager.getByIndex(index)!.id}"),
                child: _buildListItem(index),
              );
            },
            itemCount: _portManager.count,
            onReorder: (int oldIndex, int newIndex) {
              _portManager.switchOrder(newIndex, oldIndex);
              _save();
              setState(() {});
            },
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
          )
        : const Empty();
  }

  Widget _buildListItem(int index) {
    final port = _portManager.getByIndex(index)!;
    return Dismissible(
      background: Container(
        color: Colors.red[400],
        child: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red[400],
        child: const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.delete),
            content: Text(AppLocalizations.of(context)!
                .modules_tencentcloud_deleteConfirm),
            actions: [
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                child: Text(
                    AppLocalizations.of(context)!.modules_tencentcloud_confirm),
                onPressed: () => Navigator.of(context).pop(true),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.red[400],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        if (port.action == ACTION.accept.name) {
          await _close(port);
        }
        _portManager.deleteByIndex(index);
        _save();
        setState(() {});
      },
      key: Key("Dismissable_${port.id}"),
      child: SwitchListTile(
        title: Text("${port.port} ${port.protocol}"),
        subtitle: Text(port.description),
        value: port.action == ACTION.accept.name ? true : false,
        onChanged: (value) {
          if (value) {
            _open(port);
          } else {
            _close(port);
          }
        },
      ),
    );
  }

  Future<void> _reloadFromNet() async {
    if (!configured) {
      EasyLoading.showError(
          AppLocalizations.of(context)!.modules_tencentcloud_notconfigured);
      return;
    }
    await ApiService().post(
      action: "DescribeFirewallRules",
      body: {
        "InstanceId": _instanceId,
      },
    ).then((Response response) {
      final resp = ApiResponse.fromJson(response.data);
      if (!resp.isOk()) {
        return;
      }
      if (resp.data["FirewallRuleSet"] == null) {
        return;
      }
      _portManager.closeAllPort();
      final firewallRuleSet = resp.data["FirewallRuleSet"];
      for (var item in firewallRuleSet) {
        _portManager.addOrUpdate(Port.fromJson(item));
      }
      _save();
      setState(() {});
    });
  }

  Future<bool> _save() async {
    return prefs.setString(
        buildSharedPreferenceKey(moduleKey, "CachePorts-$_instanceId"),
        '{"ports": ${_portManager.toJson()}}');
  }

  Future<void> _open(Port port) async {
    EasyLoading.show(
        status: AppLocalizations.of(context)!.modules_tencentcloud_opening);
    await ApiService().post(
      action: "CreateFirewallRules",
      body: {
        "InstanceId": _instanceId,
        "FirewallRules": [
          {
            "Protocol": port.protocol,
            "Port": port.port,
            "Action": ACTION.accept.name,
            "FirewallRuleDescription": port.description,
          }
        ]
      },
    ).then((Response response) {
      final resp = ApiResponse.fromJson(response.data);
      if (resp.isOk()) {
        port.action = ACTION.accept.name;
        _portManager.addOrUpdate(port);
        _save();
        setState(() {});
      } else {
        EasyLoading.showError(AppLocalizations.of(context)!.fail);
      }
    }).then((value) => EasyLoading.dismiss());
  }

  Future<void> _close(Port port) async {
    EasyLoading.show(
        status: AppLocalizations.of(context)!.modules_tencentcloud_closing);
    await ApiService().post(
      action: "DeleteFirewallRules",
      body: {
        "InstanceId": _instanceId,
        "FirewallRules": [
          {
            "Protocol": port.protocol,
            "Port": port.port,
            "Action": port.action,
          }
        ]
      },
    ).then((response) {
      final resp = ApiResponse.fromJson(response.data);
      if (resp.isOk()) {
        port.action = ACTION.drop.name;
        _portManager.addOrUpdate(port);
        setState(() {});
      } else {
        EasyLoading.showError(AppLocalizations.of(context)!.fail);
      }
    }).then((value) => EasyLoading.dismiss());
    await _save();
  }
}
