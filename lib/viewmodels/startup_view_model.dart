import 'package:bluu/constants/route_names.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/dynamic_link_service.dart';
import 'package:bluu/services/navigation_service.dart';
import 'package:bluu/services/push_notification_service.dart';
import 'package:bluu/services/remote_config_service.dart';
import 'package:bluu/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel {
  // We'll be looking at Dependency Injection during our architecture review.
  // The next series will be on the refined and reviewed Mvvm architecture.
  // Dependency injection over service location is something that we're looking
  // at. VERY EXCITED ABOUT THE ARCHITECTURE UPDATES. We've built 6 apps with the current one
  // it works very well but there are some improvements that can be made.

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();

  Future handleStartUpLogic() async {
    await _dynamicLinkService.handleDynamicLinks();
    await _remoteConfigService.initialise();

    // Register for push notifications
    await _pushNotificationService.initialise();

    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      _navigationService.navigateHome(HomeViewRoute);
    } else {
      _navigationService.navigateHome(LoginViewRoute);
    }
  }
}
