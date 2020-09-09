
import 'package:chatapp/logic/bloc.dart';
import 'package:chatapp/logic/sharedPref_logic.dart';
import 'package:chatapp/logic/theme_chooser.dart';
import 'package:chatapp/managers/dialog_manager.dart';
import 'package:chatapp/services/analytics_service.dart';
import 'package:chatapp/services/dialog_service.dart';
import 'package:chatapp/services/navigation_service.dart';
import 'package:chatapp/startup.dart';
import 'package:chatapp/utils/locator.dart';
import 'package:chatapp/utils/router.dart';
import 'package:chatapp/utils/theme_constants.dart';
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
