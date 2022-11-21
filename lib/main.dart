import 'package:bk_app/pages/bottom_navigation.dart';
import 'package:bk_app/services/global_service.dart';
import 'package:bk_app/services/sharedpreference_service.dart';
import 'package:bk_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'modules/modules.dart';

const primaryColor = Color.fromARGB(255, 42, 96, 121);

void main() {
  runApp(const RestartWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> init() async {
    await SharedPreferenceService().init();
    await GlobalService.init();
    initModules();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(),
        builder: (_, snapshot) {
          return MaterialApp(
            builder: EasyLoading.init(),
            navigatorKey: GlobalService.navigatorKey,
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: GlobalService.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              primarySwatch: MaterialColor(
                  primaryColor.value, getPrimarySwatch(primaryColor)),
              scaffoldBackgroundColor: const Color.fromARGB(255, 242, 245, 250),
              listTileTheme: ListTileThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              appBarTheme: const AppBarTheme(
                elevation: 0.0,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                elevation: 0.0,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0.0),
                ),
              ),
            ),
            routes: {
              "/": (BuildContext context) => const BottomNavigation(),
            },
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder: (context) {
                  if (allmodulesMap.containsKey(settings.name)) {
                    return allmodulesMap[settings.name]!.func(context);
                  }
                  return Container();
                },
              );
            },
            initialRoute: "/",
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
