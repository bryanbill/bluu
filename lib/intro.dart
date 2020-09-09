import 'package:bluu/logic/bloc.dart';
import 'package:bluu/logic/sharedPref_logic.dart';
import 'package:bluu/logic/theme_chooser.dart';
import 'package:bluu/managers/dialog_manager.dart';
import 'package:bluu/services/analytics_service.dart';
import 'package:bluu/services/dialog_service.dart';
import 'package:bluu/services/navigation_service.dart';
import 'package:bluu/startup.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/utils/router.dart';
import 'package:bluu/utils/theme_constants.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
    //Initially loads Theme Color from SharedPreferences
    loadColor();
    loadCanvas();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.recieveColorName,
        initialData: Constants.initialAccent,
        builder: (context, accent) {
          return StreamBuilder(
              stream: bloc.canvasColorValue,
              builder: (context, canvas) {
                return GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: MaterialApp(
                      title: Constants.appName,
                      debugShowCheckedModeBanner: false,
                      theme: Constants.lightTheme(themeChooser(accent.data)),
                      darkTheme: Constants.darkTheme(themeChooser(accent.data)),
                      themeMode: canvasChooser(canvas.data),
                      builder: (context, child) => Navigator(
                            key: locator<DialogService>().dialogNavigationKey,
                            onGenerateRoute: (settings) => MaterialPageRoute(
                                builder: (context) =>
                                    DialogManager(child: child)),
                          ),
                      navigatorKey: locator<NavigationService>().navigationKey,
                      navigatorObservers: [
                        locator<AnalyticsService>().getAnalyticsObserver()
                      ],
                      onGenerateRoute: generateRoute,
                      home: StartUpView()),
                );
              });
        });
  }
}
