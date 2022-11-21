const Map<String, String> tcpProtocol = {
  "name": "tcp",
  "value": "TCP",
};
const udpProtocol = {
  "name": "udp",
  "value": "UDP",
};
const icmpProtocol = {
  "name": "icmp",
  "value": "ICMP",
};

enum ACTION {
  accept,
  drop,
}

extension ActionExtension on ACTION {
  String get name {
    switch (this) {
      case ACTION.accept:
        return "ACCEPT";
      case ACTION.drop:
        return "DROP";
      default:
        return "";
    }
  }
}
