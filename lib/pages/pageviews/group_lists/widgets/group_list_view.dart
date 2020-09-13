import 'package:bluu/pages/chatscreens/widgets/cached_image.dart';
import 'package:bluu/pages/groupchatscreens/group_chat_screen.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluu/models/group.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/provider/user_provider.dart';
import 'package:bluu/resources/group_methods.dart';
import 'package:bluu/widgets/custom_tile.dart';

import 'last_message_container.dart';
import 'online_dot_indicator.dart';

class GroupListView extends StatelessWidget {
  final Group group;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  GroupListView(this.group);

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      group: group,
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Group group;
  final GroupMethods _groupMethods = GroupMethods();

  ViewLayout({
    @required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatScreen(
              receiver: group,
            ),
          )),
      title: Padding(
        padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
        child: Text(
          (group != null ? group.name : null) != null ? group.name : "..",
          style: TextStyle(fontFamily: "Arial", fontSize: 19),
        ),
      ),
      subtitle: Padding(
          padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
          child: Text("Last Message will be here")),

      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              group.avatar,
              radius: 80,
              isRound: true,
            ),
          ],
        ),
      ),
    );
  }
}
