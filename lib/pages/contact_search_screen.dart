import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/resources/contact_methods.dart';
import 'package:chatapp/services/authentication_service.dart';
import 'package:chatapp/services/firestore_service.dart';
import 'package:chatapp/utils/locator.dart';
import 'package:chatapp/widgets/mainappbar_style.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:chatapp/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

import 'callscreens/pickup/pickup_layout.dart';
import 'chatscreens/chat_screen.dart';

class ContactSearchScreen extends StatefulWidget {
  @override
  _ContactSearchScreenState createState() => _ContactSearchScreenState();
}

class _ContactSearchScreenState extends State<ContactSearchScreen> {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
final FirestoreService _firestoreService =
      locator<FirestoreService>();
  final ContactMethods _contactMethods = ContactMethods();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

     var user = _authenticationService.currentUser;
    _firestoreService.fetchAllUsers(user).then((List<User> list) {
      setState(() {
        userList = list;
      });
    }); 
  }
searchBar(context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      title: TextField(
        controller: searchController,
        onChanged: (val) {
          setState(() {
            query = val;
          });
        },
        autofocus: true,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => searchController.clear(),
            icon: Icon(Icons.clear),
          ),
          hintText: 'Search',
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.filter_list,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  buildSuggestions(UserProvider userProvider, String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((User user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.name.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (matchesUsername || matchesName);
              }).toList()
            : [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username,
            firebaseToken: suggestionList[index].firebaseToken);
        // print("Role: " + searchedUser.role);
        return CustomTile(
          mini: false,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        receiver: searchedUser,
                      ))),
          title: Padding(
            padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
            child: Text(
              searchedUser.name,
              style: TextStyle(
          
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
            child: Text(
              searchedUser.username,
            
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: UniversalVariables.greyColor,
          ),
          trailing: Container(
              decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              // color: UniversalVariables.blueColor,
              //TODO: ADDCONNTACTTODB
              child: FlatButton(
                color: Theme.of(context).accentColor,
                  onPressed: () => _contactMethods.addContactToDb(
                      userProvider.getUser, searchedUser),
                  child: Text(
                    "Add Contact",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))),
        );

      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return PickupLayout(
      scaffold: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: searchBar(context),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(userProvider, query),
        ),
      ),
    );
  }
}
