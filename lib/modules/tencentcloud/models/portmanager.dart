import 'package:bk_app/modules/tencentcloud/models/common.dart';
import 'package:bk_app/modules/tencentcloud/utils/constants.dart';

class PortManager {
  final Map<String, Port> _ports = {};
  final List<String> _localPorts = [];
  final List<String> _remotePorts = [];
  static final PortManager _singleton = PortManager._internal();
  factory PortManager() => _singleton;
  PortManager._internal();

  void add(Port port, {bool isLocal = false}) {
    _ports[port.id] = port;
    if (isLocal) {
      if (_remotePorts.contains(port.id)) {
        _remotePorts.remove(port.id);
      }
      if (!_localPorts.contains(port.id)) {
        _localPorts.add(port.id);
      }
    } else {
      if (_localPorts.contains(port.id)) {
        _localPorts.remove(port.id);
      }
      if (!_remotePorts.contains(port.id)) {
        _remotePorts.add(port.id);
      }
    }
  }

  void delete(Port port) {
    _ports.remove(port.id);
  }

  // get sorted ports
  List<Port> get sortedPorts {
    return _ports.values.toList()..sort((a, b) => a.port.compareTo(b.port));
  }

  List<dynamic> toJson() {
    return _ports.values.toList();
  }

  void remove(Port port) {
    _ports.remove(port.id);
    _localPorts.remove(port.id);
    _remotePorts.remove(port.id);
  }

  int get count => _ports.length;

  void clear() {
    _ports.clear();
    _localPorts.clear();
    _remotePorts.clear();
  }

  void updateLocalPortToClose() {
    for (var portId in _localPorts) {
      _ports[portId]?.action = action.drop.name;
    }
  }
}
