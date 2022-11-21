import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'scanner.dart';
import 'generator.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final List<Widget Function(BuildContext)> _nav = [
    (BuildContext context) => const Scanner(),
    (BuildContext context) => const Generator(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _nav[_currentIndex](context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            label: AppLocalizations.of(context)!.modules_qrcode_scan,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fiber_new_outlined),
            label: AppLocalizations.of(context)!.modules_qrcode_generate,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return null;
      case 1:
        return AppBar(
          title: Text(AppLocalizations.of(context)!.modules_qrcode_generate),
        );
      default:
        return AppBar(
          title: Text(AppLocalizations.of(context)!.unknown),
        );
    }
  }
}
