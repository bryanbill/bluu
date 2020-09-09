import 'package:chatapp/pages/callscreens/pickup/pickup_layout.dart';
import 'package:chatapp/pages/pageviews/chat_lists/widgets/chat_list_view.dart';
import 'package:chatapp/pages/pageviews/chat_lists/widgets/new_chat_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/models/contact.dart';
import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/resources/chat_methods.dart';
import 'package:chatapp/widgets/quiet_box.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        body: ChatListContainer(),
        floatingActionButton: NewChatButton(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchMessageContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            print("User Provier: ");
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return ContactQuietBox();
              }
              return ListView.separated(
                padding: EdgeInsets.all(10),
                separatorBuilder: (BuildContext context, int index) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: SizedBox(),
                    ),
                  );
                },
                itemCount: docList.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = Contact.fromMap(docList[index].data);
                  return ChatListView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
