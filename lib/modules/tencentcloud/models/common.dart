import 'package:bk_app/modules/tencentcloud/utils/constants.dart';

Map<String, String> defProtocol = {
  tcpProtocol["name"]!: tcpProtocol["value"]!,
  udpProtocol["name"]!: udpProtocol["value"]!,
  icmpProtocol["name"]!: icmpProtocol["value"]!,
};
const Map<bool, String> defStatus = {true: 'ACCEPT', false: 'DROP'};

class Port {
  Port({
    required this.port,
    required this.protocol,
    this.status = "",
    this.description = '',
  });
  String port;
  String protocol;
  String status;
  String description;
  Port.fromJson(Map<String, dynamic> json)
      : port = json['Port']!,
        protocol = json['Protocol']!,
        status = json['Action'],
        description = json['FirewallRuleDescription'] ?? "无";
  Map<String, dynamic> toJson() => {
        "Port": port,
        "Protocol": protocol,
        "Action": status,
        "FirewallRuleDescription": description,
      };

  String get id => "$port-$protocol";
}
