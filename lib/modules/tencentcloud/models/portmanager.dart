import 'dart:convert';

import 'package:bk_app/modules/tencentcloud/models/common.dart';
import 'package:bk_app/modules/tencentcloud/utils/constants.dart';

class PortManager {
  final Map<String, Port> _uniquePorts = {}; // key: port.id, value: Port
  final List<String> _portIds = [];

  void switchOrder(int newIndex, int oldIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    _portIds.insert(newIndex, _portIds.removeAt(oldIndex));
  }

  void closeAllPort() {
    for (var element in _uniquePorts.values) {
      element.action = ACTION.drop.name;
    }
  }

  bool _isValidIndex(int index) {
    return index < _portIds.length;
  }

  void addOrUpdate(Port port) {
    if (_uniquePorts.containsKey(port.id)) {
      _uniquePorts[port.id] = port;
      return;
    }
    _uniquePorts[port.id] = port;
    _portIds.add(port.id);
  }

  bool update(Port port) {
    if (!_uniquePorts.containsKey(port.id)) {
      return false;
    }
    _uniquePorts[port.id] = port;
    return true;
  }

  Port? getByIndex(int index) {
    if (_isValidIndex(index)) {
      return _uniquePorts[_portIds[index]];
    }
    return null;
  }

  bool deleteByIndex(int index) {
    if (!_isValidIndex(index)) {
      return false;
    }
    _uniquePorts.remove(_portIds.removeAt(index));
    return true;
  }

  String toJson() {
    List<Port> data = [];
    for (var portId in _portIds) {
      data.add(_uniquePorts[portId]!);
    }
    return jsonEncode(data, toEncodable: (Object? e) => (e as Port).toJson());
  }

  int get count => _uniquePorts.length;

  void clear() {
    _uniquePorts.clear();
    _portIds.clear();
  }
}
