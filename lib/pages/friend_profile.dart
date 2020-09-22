import 'dart:math';
import 'package:bluu/models/user.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:flutter/material.dart';
import 'callscreens/pickup/pickup_layout.dart';

class FriendProfile extends StatefulWidget {
  final User contact;
  const FriendProfile({Key key, this.contact}) : super(key: key);
  @override
  _FriendProfileState createState() => _FriendProfileState(uid: contact.uid);
}

class _FriendProfileState extends State<FriendProfile> {
  final String uid;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  static Random random = Random();

  _FriendProfileState({this.uid});

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: StreamBuilder(
          stream: _firestoreService.getUserStream(uid: uid),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        user.verified
                            ? Icon(
                                Icons.verified_user,
                                color: Theme.of(context).accentColor,
                                size: 20,
                              )
                            : SizedBox()
                      ],
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
                            Icons.message,
                            color: Colors.white,
                          ),
                          color: Colors.greenAccent,
                          onPressed: () {},
                        ),
                        SizedBox(width: 4),
                        FlatButton(
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          color: Colors.blueAccent,
                          onPressed: () {},
                        ),
                        SizedBox(width: 4),
                        FlatButton(
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          onPressed: () {},
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
