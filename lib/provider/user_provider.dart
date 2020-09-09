import 'package:chatapp/services/authentication_service.dart';
import 'package:chatapp/services/firestore_service.dart';
import 'package:chatapp/utils/locator.dart';
import 'package:flutter/widgets.dart';
import 'package:chatapp/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user;
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  User get getUser => _user;
 
  refreshUser() {
    _firestoreService
        .getUserStream(uid: _authenticationService.currentUser.uid)
        .listen((event) {
      var data = event.data;
     _user = User.fromMap(data);
    });
  }
}
