import 'package:bk_app/pages/home.dart';
import 'package:bk_app/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final List<Widget Function(BuildContext)> _nav = [
    (BuildContext context) => Home(key: UniqueKey()),
    (BuildContext context) => const Setting(),
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
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.setting,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return AppBar(
          title: Text(AppLocalizations.of(context)!.home),
        );
      case 1:
        return AppBar(
          title: Text(AppLocalizations.of(context)!.setting),
        );
      default:
        return AppBar(
          title: Text(AppLocalizations.of(context)!.unknown),
        );
    }
  }
}
