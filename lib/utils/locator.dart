import 'package:chatapp/services/analytics_service.dart';
import 'package:chatapp/services/authentication_service.dart';
import 'package:chatapp/services/cloud_storage_service.dart';
import 'package:chatapp/services/dynamic_link_service.dart';
import 'package:chatapp/services/firestore_service.dart';
import 'package:chatapp/services/push_notification_service.dart';
import 'package:chatapp/services/remote_config_service.dart';
import 'package:chatapp/utils/image_selector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/services/navigation_service.dart';
import 'package:chatapp/services/dialog_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => FirebaseMessaging());

  var remoteConfigService = await RemoteConfigService.getInstance();
  locator.registerSingleton(remoteConfigService);
}
