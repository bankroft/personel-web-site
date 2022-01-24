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

enum action {
  accept,
  drop,
}

extension ActionExtension on action {
  String get name {
    switch (this) {
      case action.accept:
        return "ACCEPT";
      case action.drop:
        return "DROP";
      default:
        return "";
    }
  }
}
