import 'package:bluu/services/analytics_service.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/cloud_storage_service.dart';
import 'package:bluu/services/dynamic_link_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/services/push_notification_service.dart';
import 'package:bluu/services/remote_config_service.dart';
import 'package:bluu/services/storage_service.dart';
import 'package:bluu/utils/image_selector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:bluu/services/navigation_service.dart';
import 'package:bluu/services/dialog_service.dart';

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
  locator.registerLazySingleton(() => StorageService());
  var remoteConfigService = await RemoteConfigService.getInstance();
  locator.registerSingleton(remoteConfigService);
}
