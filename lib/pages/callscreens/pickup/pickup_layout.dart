import 'package:bluu/pages/callscreens/pickup/pickup_screen.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluu/models/call.dart';
import 'package:bluu/provider/user_provider.dart';
import 'package:bluu/resources/call_methods.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
   
    return (_authenticationService.currentUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: _authenticationService.currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data != null) {
                Call call = Call.fromMap(snapshot.data.data);
                print(_authenticationService.currentUser.email);
                if (!call.hasDialled) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: Text("noooothhingghjgjhkh"),
            ),
          );
  }
}
