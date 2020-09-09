import 'dart:async';

import 'package:chatapp/components/dialog.dart';
import 'package:chatapp/pages/dashboard_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/userprofile.dart';
import 'package:connectivity/connectivity.dart';import 'package:chatapp/enum/user_state.dart';
import 'package:chatapp/pages/pageviews/group_lists/group_list_screen.dart';
import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/services/authentication_service.dart';
import 'package:chatapp/services/firestore_service.dart';
import 'package:chatapp/utils/locator.dart';
import 'package:chatapp/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'callscreens/pickup/pickup_layout.dart';

import 'chats_calls.dart';
import 'pageviews/contact_lists/contact_list_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  PageController _pageController;
  int _page = 2;
  
  UserProvider userProvider;
   String currentUserId;
  String initials;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  _MainScreenState();
  var connectivityStatus = 'Unknown';

  //This is verify the Internet Access.
  Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> connectivitySubs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          ChatsCalls(),
          ContactListScreen(),
          // // Container(
          //   child: LogScreen(),
          // ),
          HomePage(),
          DashBoard(),
          UserProfile()
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Theme.of(context).canvasColor,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.grey[500]),
              ),
        ),
        child: BottomNavigationBar(
          elevation: 4.0,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Container(height: 0.0),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _firestoreService.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    _firestoreService
        .getUser(_authenticationService.currentUser.uid)
        .then((user) {
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.name);
      });
    });
    _pageController = PageController(initialPage: 2);
    connectivitySubs =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityStatus = result.toString();
      if (result == ConnectivityResult.none) {
        noInternetDialog(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    connectivitySubs.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
 @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _firestoreService.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _firestoreService.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _firestoreService.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _firestoreService.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }
  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
