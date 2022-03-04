import 'package:bk_app/pages/bottom_navigation.dart';
import 'package:bk_app/services/global_service.dart';
import 'package:bk_app/services/sharedpreference_service.dart';
import 'package:bk_app/states/l10nstates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'modules/modules.dart';

void main() {
  runApp(ChangeNotifierProvider<LocalizationsState>(
    create: (context) => LocalizationsState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await SharedPreferenceService().init();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationsState>(
      builder: (context, value, child) => FutureBuilder(
        future: value.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              navigatorKey: GlobalService.navigatorKey,
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: value.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              routes: {
                "/": (BuildContext context) => const BottomNavigation(),
                // "/home": (BuildContext context) => const Home(),
                // "/setting": (BuildContext context) => const Setting(),
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
          }
          return Container();
        },
      ),
    );
  }
}
