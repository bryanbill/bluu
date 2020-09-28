import 'package:bluu/pages/callscreens/pickup/pickup_layout.dart';
import 'package:bluu/pages/pageviews/contact_lists/widgets/contact_list_view.dart';
import 'package:bluu/pages/pageviews/contact_lists/widgets/new_chat_button.dart';
import 'package:bluu/resources/contact_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluu/models/contact.dart';
import 'package:bluu/provider/user_provider.dart';
import 'package:bluu/widgets/quiet_box.dart';

class ContactListScreen extends StatelessWidget {
  final bool messageScreen;

  const ContactListScreen({Key key, @required this.messageScreen})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        body: ContactListContainer(
          messageScreen: messageScreen,
        ),
        floatingActionButton: NewChatButton(),
      ),
    );
  }
}

class ContactListContainer extends StatelessWidget {
  final ContactMethods _contactMethods = ContactMethods();
  final bool messageScreen;

  ContactListContainer({Key key, this.messageScreen}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: TextField(
          decoration: InputDecoration.collapsed(
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
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: _contactMethods.fetchContacts(
              userId: userProvider.getUser.uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docList = snapshot.data.documents;

                if (docList.isEmpty) { 
                  return ContactQuietBox();
                }
                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: docList.length,
                  itemBuilder: (context, index) {
                    Contact contact = Contact.fromMap(docList[index].data);

                    return ContactListView(
                        contact: contact, messageScreen: messageScreen);
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
