import 'package:flutter/material.dart';

class BaseModule extends StatelessWidget {
  static get name {
    throw UnimplementedError();
  }

  const BaseModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class ModuleDefs {
  String route;
  Widget Function(BuildContext context) func;
  String? icon;
  String Function() name;
  String Function()? description;
  ModuleDefs({
    required this.route,
    required this.func,
    required this.name,
    this.icon,
    this.description,
  });
}
