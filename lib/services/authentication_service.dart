import 'package:bluu/pages/pin_verification_screen.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/services/analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:bluu/services/firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  FirebaseMessaging _firebaseMessaging = locator<FirebaseMessaging>();
  User _currentUser;
  User get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future phoneAuth({@required String phone}) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential _authCred) {
          //code for navigating to next step
        },
        verificationFailed: (AuthException _authExc) {},
        codeSent: (String verificationId, [int forceResendingToken]) {
          return PinCodeVerificationScreen(
              phoneNumber: phone, forceResendingToken: forceResendingToken, verificationId: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Time out");
        });
  }

  Future phoneVerify({String code, verificationId, phone}) async {
    try {
      String smsCode = code.trim();
      var _cred = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: smsCode);
      AuthResult result;
      await _firebaseAuth
          .signInWithCredential(_cred)
          .then((value) => result = value);

      String token = await _firebaseMessaging.getToken().then((deviceToken) {
        return deviceToken.toString();
      });

      _currentUser = User(
          phone: phone,
          uid: result.user.uid,
          email: phone+'@bluu.spac.e',
          name: 'Bluu User'+phone[05],
          firebaseToken: token,
          username: phone,
          status: "Yeyy! Bluu rocks🥳",
          public: true,
          profilePhoto:
              "https://images.unsplash.com/photo-1599990323348-b8aebea736cf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
          verified: false);
      await _firestoreService.createUser(_currentUser);
      await _analyticsService.setUserProperties(
        userId: result.user.uid,
        userRole: _currentUser.verified.toString(),
      );
      return result.user !=null;
    } catch (e) {
      print(e.message);
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String token = await _firebaseMessaging.getToken().then((deviceToken) {
        return deviceToken.toString();
      });

      // create a new user profile on firestore
      _currentUser = User(
          uid: authResult.user.uid,
          email: email,
          name: fullName,
          firebaseToken: token,
          username: '@' + fullName.split(" ")[0] ?? fullName,
          status: "Yeyy! Bluu rocks🥳",
          public: true,
          profilePhoto:
              "https://images.unsplash.com/photo-1599990323348-b8aebea736cf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
          verified: false);

      await _firestoreService.createUser(_currentUser);
      await _analyticsService.setUserProperties(
        userId: authResult.user.uid,
        userRole: _currentUser.state.toString(),
      );

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null;
  }

  Future signOut() async {
    await _firebaseAuth.signOut().then((v) {
      print("signed out");
    });
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
      await _analyticsService.setUserProperties(
        userId: user.uid,
        userRole: _currentUser.state.toString(),
      );
    }
  }
}
