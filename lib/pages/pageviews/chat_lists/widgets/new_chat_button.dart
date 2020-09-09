import 'package:chatapp/pages/pageviews/contact_lists/contact_list_screen.dart';
import 'package:flutter/material.dart';
import '../../../group_search_screen.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ContactListScreen()));
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: Icon(
          Icons.add_comment,
          color: Colors.white,
          size: 25,
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}

class NewGroupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => GroupSearchScreen()));
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: Icon(
          Icons.group_add,
          color: Colors.white,
          size: 25,
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
