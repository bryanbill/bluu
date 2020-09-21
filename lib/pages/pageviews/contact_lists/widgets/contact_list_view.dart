import 'package:bluu/pages/chatscreens/chat_screen.dart';
import 'package:bluu/pages/chatscreens/widgets/cached_image.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:bluu/models/contact.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/widgets/custom_tile.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../friend_profile.dart';
import 'online_dot_indicator.dart';

class ContactListView extends StatelessWidget {
  final Contact contact;
  final bool messageScreen;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  ContactListView({this.contact, this.messageScreen});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _firestoreService.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
            messageScreen: messageScreen,
          );
        }
        return SizedBox();
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final bool messageScreen;
  ViewLayout({@required this.contact, this.messageScreen});

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      swipeDirection: SwipeDirection.swipeToLeft,
      callBack: () {
        messageScreen
            ? Get.to(FriendProfile(contact: contact))
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    receiver: contact,
                  ),
                ));
      },
      child: CustomTile(
        mini: false,
        onTap: () => messageScreen
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    receiver: contact,
                  ),
                ))
            : Get.to(FriendProfile(contact: contact)),
        title: Padding(ew message-
          padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
          child: Text(
            (contact != null ? contact.name : null) != null
                ? contact.name
                : "..",
            style: TextStyle(fontFamily: "Arial", fontSize: 19),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
          child: Text(contact.status ?? '...'),
        ),
        leading: Container(
          constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
          child: Stack(
            children: <Widget>[
              CachedImage(
                contact.profilePhoto,
                radius: 80,
                isRound: true,
              ),
              OnlineDotIndicator(
                uid: contact.uid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
