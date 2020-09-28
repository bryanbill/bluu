import 'package:bluu/utils/locator.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:bluu/provider/image_upload_provider.dart';
import 'package:bluu/provider/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'logic/bloc.dart';
import 'logic/sharedPref_logic.dart';
import 'logic/theme_chooser.dart';
import 'managers/dialog_manager.dart';
import 'services/analytics_service.dart';
import 'services/dialog_service.dart';
import 'services/navigation_service.dart';
import 'startup.dart';
import 'utils/router.dart';
import 'utils/theme_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Following code will Force the App Orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Register all the models and services before the app starts
  await setupLocator();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main> {
  FirebaseMessaging _firebaseMessaging = locator<FirebaseMessaging>();
  @override
  void initState() {
    super.initState();
    //Initially loads Theme Color from SharedPreferences
    loadColor();
    loadCanvas();
    Future.delayed(Duration(milliseconds: 500), () {
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: StreamBuilder(
            stream: bloc.recieveColorName,
            initialData: Constants.initialAccent,
            builder: (context, accent) {
              return StreamBuilder(
                  stream: bloc.canvasColorValue,
                  builder: (context, canvas) {
                    return GetMaterialApp(
                        title: Constants.appName,
                        debugShowCheckedModeBanner: false,
                        theme: Constants.lightTheme(themeChooser(accent.data)),
                        darkTheme:
                            Constants.darkTheme(themeChooser(accent.data)),
                        themeMode: canvasChooser(canvas.data),
                        builder: (context, child) => Navigator(
                              key: locator<DialogService>().dialogNavigationKey,
                              onGenerateRoute: (settings) => MaterialPageRoute(
                                  builder: (context) =>
                                      DialogManager(child: child)),
                            ),
                        navigatorKey:
                            locator<NavigationService>().navigationKey,
                        navigatorObservers: [
                          locator<AnalyticsService>().getAnalyticsObserver()
                        ],
                        onGenerateRoute: generateRoute,
                        home: StartUpView());
                  });
            }));
  }
}
