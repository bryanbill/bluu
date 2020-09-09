import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:flutter/widgets.dart';
import 'package:bluu/models/user.dart';

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
