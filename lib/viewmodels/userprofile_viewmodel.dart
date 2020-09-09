import 'package:chatapp/models/user.dart';
import 'package:chatapp/services/firestore_service.dart';
import 'package:chatapp/services/navigation_service.dart';
import 'package:chatapp/utils/locator.dart';
import 'package:chatapp/viewmodels/base_model.dart';

class UserProfileViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _user;
  
}