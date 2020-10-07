import 'dart:math';
import 'package:bluu/components/account_update.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/pages/settings_page.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  final List<List<double>> charts = [
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ]
  ];

  static final List<String> chartDropdownItems = [
    'Last 7 days',
    'Last month',
    'Last year'
  ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Theme.of(context).accentColor,
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                SizedBox(height: 10),
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
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                Expanded(
                  child: StaggeredGridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    children: <Widget>[
                      _buildTile(
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total Views',
                                        style: TextStyle(
                                            color: Colors.blueAccent)),
                                    Text('265K',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 30.0))
                                  ],
                                ),
                                Material(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(Icons.timeline,
                                          color: Colors.white, size: 30.0),
                                    )))
                              ]),
                        ),
                      ),
                      _buildTile(
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Material(
                                    color: Colors.teal,
                                    shape: CircleBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(Icons.settings_applications,
                                          color: Colors.white, size: 30.0),
                                    )),
                                Padding(padding: EdgeInsets.only(bottom: 16.0)),
                                Text('General',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.0)),
                                Text('Images, Videos'),
                              ]),
                        ),
                      ),
                      _buildTile(
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Material(
                                    color: Colors.amber,
                                    shape: CircleBorder(),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Icon(Icons.notifications,
                                          color: Colors.white, size: 30.0),
                                    )),
                                Padding(padding: EdgeInsets.only(bottom: 16.0)),
                                Text('Alerts',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.0)),
                                Text('All'),
                              ]),
                        ),
                      ),
                      _buildTile(
                        Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Revenue',
                                            style:
                                                TextStyle(color: Colors.green)),
                                        Text('\$16K',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 34.0)),
                                      ],
                                    ),
                                    DropdownButton(
                                        isDense: true,
                                        value: actualDropdown,
                                        onChanged: (String value) =>
                                            setState(() {
                                              actualDropdown = value;
                                              actualChart =
                                                  chartDropdownItems.indexOf(
                                                      value); // Refresh the chart
                                            }),
                                        items: chartDropdownItems
                                            .map((String title) {
                                          return DropdownMenuItem(
                                            value: title,
                                            child: Text(title,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.0)),
                                          );
                                        }).toList())
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 4.0)),
                                Sparkline(
                                  data: charts[actualChart],
                                  lineWidth: 5.0,
                                  lineColor: Colors.greenAccent,
                                )
                              ],
                            )),
                      ),
                      _buildTile(
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Shop Items',
                                        style:
                                            TextStyle(color: Colors.redAccent)),
                                    Text('173',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 30.0))
                                  ],
                                ),
                                Material(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: Center(
                                        child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Icon(Icons.store,
                                          color: Colors.white, size: 30.0),
                                    )))
                              ]),
                        ),
                        onTap: () {},
                      )
                    ],
                    staggeredTiles: [
                      StaggeredTile.extent(2, 110.0),
                      StaggeredTile.extent(1, 180.0),
                      StaggeredTile.extent(1, 180.0),
                      StaggeredTile.extent(2, 220.0),
                      StaggeredTile.extent(2, 110.0),
                    ],
                  ),
                ),
              ],
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
