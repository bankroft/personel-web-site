import 'dart:convert';

import '../utils/constants.dart';
import '../widgets/add.dart';

import '../models/apiresponse.dart';
import '../models/common.dart';
import '../models/portmanager.dart';
import 'package:dio/dio.dart';
import 'package:motion_toast/motion_toast.dart';
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
        reload();
      }
    });
  }

  void reload() {
    PortManager().clear();
    setState(() {});
    if (!configured) {
      return;
    }
    if (prefs.containsKey(
        buildSharedPreferenceKey(moduleKey, "CachePorts-$_instanceId"))) {
      final cachePorts = prefs.getString(
          buildSharedPreferenceKey(moduleKey, "CachePorts-$_instanceId"))!;
      final ports = jsonDecode(cachePorts) as List<dynamic>;
      for (var element in ports) {
        final port = Port.fromJson(element);
        PortManager().add(port, isLocal: true);
      }
      setState(() {});
    }
    _reloadFromNet();
  }

  @override
  Widget build(BuildContext context) {
    final sortedPorts = PortManager().sortedPorts;
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
        onRefresh: () async => reload(),
        child: ListView.separated(
          itemBuilder: (_, index) {
            return _buildListItem(sortedPorts[index]);
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: sortedPorts.length,
        ),
      ),
    );
  }

  Widget _buildListItem(Port port) {
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
        await _close(port);
        PortManager().remove(port);
        save();
        setState(() {});
      },
      key: Key(port.id),
      child: ListTile(
        title: Text("${port.port} ${port.protocol}"),
        subtitle: Text(port.description),
        trailing: Switch(
          value: port.action == action.accept.name ? true : false,
          onChanged: (value) {
            if (value) {
              _open(port);
            } else {
              _close(port);
            }
          },
        ),
      ),
    );
  }

  void _reloadFromNet() {
    if (!configured) {
      MotionToast.error(
        description: const Text("TODO"),
      ).show(context);
      return;
    }
    ApiService().post(
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
      final firewallRuleSet = resp.data["FirewallRuleSet"];
      for (var item in firewallRuleSet) {
        PortManager().add(Port.fromJson(item));
      }
      PortManager().updateLocalPortToClose();
      save();
      setState(() {});
    });
  }

  Future<bool> save() async {
    final cachePorts = PortManager().toJson();
    return prefs.setString(
        buildSharedPreferenceKey(moduleKey, "CachePorts-$_instanceId"),
        jsonEncode(cachePorts));
  }

  Future<void> _open(Port port) async {
    await ApiService().post(
      action: "CreateFirewallRules",
      body: {
        "InstanceId": _instanceId,
        "FirewallRules": [
          {
            "Protocol": port.protocol,
            "Port": port.port,
            "Action": action.accept.name,
            "FirewallRuleDescription": port.description,
          }
        ]
      },
    ).then((Response response) {
      final resp = ApiResponse.fromJson(response.data);
      if (resp.isOk()) {
        port.action = action.accept.name;
        PortManager().add(port);
        save();
        setState(() {});
      }
    });
  }

  Future<void> _close(Port port) async {
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
        port.action = action.drop.name;
        PortManager().add(port);
        setState(() {});
      }
    });
    await save();
  }
}
