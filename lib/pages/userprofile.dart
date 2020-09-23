import 'dart:math';
import 'package:bluu/components/account_update.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/pages/settings_page.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:flutter/material.dart';
import 'callscreens/pickup/pickup_layout.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  static Random random = Random();

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: StreamBuilder(
          stream: _firestoreService.getUserStream(
              uid: _authenticationService.currentUser.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }
            User user = User.fromMap(snapshot.data.data);
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 60),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePhoto ??
                          "https://images.unsplash.com/photo-1599477167833-c0215a3df921?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      user.status ?? "..",
                      style: TextStyle(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton(
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => SettingsScreen()));
                          },
                        ),
                        SizedBox(width: 10),
                        FlatButton(
                          child: Icon(
                            Icons.account_box,
                            color: Colors.white,
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            return showAccountSettings(context, user);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildCategory("Posts"),
                          _buildCategory("Friends"),
                          _buildCategory("Groups"),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      padding: EdgeInsets.all(5),
                      itemCount: 15,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 200 / 200,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/images/${random.nextInt(6)}.jpg",
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    ));
  }

  showAccountSettings(context, User user) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        builder: (context) {
          return AccountUpdate(
              userId: _authenticationService.currentUser.uid,
              userName: user.username,
              fullName: user.name,
              userEmail: user.email,
              userStatus: user.status,
              userProfilePic: user.profilePhoto);
        });
  }

  Widget _buildCategory(String title) {
    return Column(
      children: <Widget>[
        Text(
          random.nextInt(10000).toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(),
        ),
      ],
    );
  }
}
