import 'package:bk_app/pages/bottom_navigation.dart';
import 'package:bk_app/services/global_service.dart';
import 'package:bk_app/services/sharedpreference_service.dart';
import 'package:bk_app/states/l10nstates.dart';
import 'package:bk_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'modules/modules.dart';

const primaryColor = Color.fromARGB(255, 42, 96, 121);

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
              builder: EasyLoading.init(),
              navigatorKey: GlobalService.navigatorKey,
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: value.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                primarySwatch: MaterialColor(
                    primaryColor.value, getPrimarySwatch(primaryColor)),
                scaffoldBackgroundColor:
                    const Color.fromARGB(255, 242, 245, 250),
                listTileTheme: ListTileThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 0.0,
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
          }
          return Container();
        },
      ),
    );
  }
}
