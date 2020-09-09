import 'package:bluu/models/user.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/services/navigation_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/viewmodels/base_model.dart';

class UserProfileViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _user;
}
