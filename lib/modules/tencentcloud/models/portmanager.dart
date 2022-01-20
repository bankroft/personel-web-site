import 'package:bk_app/modules/tencentcloud/models/common.dart';

class PortManager {
  // List<Port> _ports = [];
  final Map<String, Port> _ports = {};
  static final PortManager _singleton = PortManager._internal();
  factory PortManager() => _singleton;
  PortManager._internal();

  void add(Port port) {
    _ports[port.id] = port;
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
  }

  int get count => _ports.length;
}
