import 'package:bluu/models/contact.dart';
import 'package:bluu/models/group.dart';
import 'package:bluu/models/group_members.dart';
import 'package:bluu/models/text_controller.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/resources/contact_methods.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/widgets/quiet_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'callscreens/pickup/pickup_layout.dart';
import 'chatscreens/widgets/cached_image.dart';

class NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

final AuthenticationService _authenticationService =
    locator<AuthenticationService>();
final ContactMethods _contactMethods = ContactMethods();
final FirestoreService _firestoreService = locator<FirestoreService>();

///groupMembersAdd.members.add(_authenticationService.currentUser.uid);

class _NewGroupState extends State<NewGroup> {
  TextEditingController _text = TextEditingController();
  TextEditingController _editingController = TextEditingController();
  final GroupMembersAdd groupMembersAdd = Get.put(GroupMembersAdd());
  final TextCountController textCountController =
      Get.put(TextCountController());
  createGroup(Group group) {}
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          int chars = 0;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: new Container(
                width: 400.0,
                height: 234.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // dialog centre
                    new Container(
                      child: new TextFormField(
                        controller: _editingController,
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(256),
                        ],
                        onChanged: (value) {
                          setState(() {
                            chars = value.length;
                          });
                        },
                        maxLines: null,
                        decoration: new InputDecoration(
                          suffix: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Text("$chars",
                                style: TextStyle(
                                    color:
                                        256 - chars < 10 ? Colors.red : null)),
                          ),
                          labelText: "Description",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Can't be blank!";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),

                    // dialog bottom
                    new Container(
                      padding: new EdgeInsets.all(16.0),
                      decoration: new BoxDecoration(),
                      child: FlatButton(
                        highlightColor: Theme.of(context).accentColor,
                        onPressed: () async {
                          Group group = Group(
                              uid: _authenticationService.currentUser.uid,
                              name: _text.text,
                              users: groupMembersAdd.members+[_authenticationService.currentUser.uid],
                              avatar:
                                  "https://images.unsplash.com/photo-1599968457111-a917cc30bc06?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                              public: true,
                              limit: false,
                              link: _text.text + '.io',
                              desc: _editingController.text,
                              createdOn: Timestamp.now());
                          await _firestoreService
                              .createGroup(group)
                              .then((value) {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                            Get.back();
                          });
                        },
                        child: new Text(
                          'Create Group',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'helvetica_neue_light',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget contactList(context, Contact contact) {
    return FutureBuilder<User>(
      future: _firestoreService.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        User user = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Container(
              width: 300,
              child: GetBuilder<GroupMembersAdd>(
                builder: (value) => ListTile(
                    leading: CachedImage(
                      user.profilePhoto,
                      radius: 50,
                      isRound: true,
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.username ?? '..'),
                    trailing: value.members != null
                        ? value.members.contains(user.uid)
                            ? IconButton(
                                icon: Icon(Icons.done,
                                    color: Theme.of(context).accentColor),
                                onPressed: () {
                                  value.remove(user.uid);
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  value.add(user.uid);
                                })
                        : IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              value.add(user.uid);
                            })),
              ),
            );
          }
          return SizedBox();
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          title: GetBuilder<TextCountController>(
              builder: (textCount) => TextField(
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(20),
                    ],
                    controller: _text,
                    onChanged: (value) {
                      textCount.increment(value);
                    },
                    decoration: InputDecoration(
                      suffix: Text(
                          (20 - int.parse(textCount.count.toString()))
                              .toString(),
                          style: TextStyle(
                              color:
                                  (20 - int.parse(textCount.count.toString()) <
                                          6)
                                      ? Colors.red
                                      : null)),
                    ),
                  )),
          actions: [
            IconButton(
              icon: Icon(Icons.create),
              onPressed: () {
                if (textCountController.count != RxInt(0) &&
                    groupMembersAdd.members.length != 0)
                  _displayDialog(context);
              },
            )
          ],
        ),
        body: GetBuilder<GroupMembersAdd>(
            init: GroupMembersAdd(),
            builder: (value) => Column(
                  children: [
                    Container(
                        child: Text(value.members != null
                            ? value.members.length.toString()
                            : "0")),
                    Container(
                      height: 200,
                      child: value.members != null
                          ? ListView.builder(
                              itemCount: value.members.length,
                              itemBuilder: (context, index) {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: _firestoreService.getUserStream(
                                        uid: value.members[index]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var docList = snapshot.data;

                                        if (docList.isNull) {
                                          return SizedBox();
                                        }
                                        User memberInfo =
                                            User.fromMap(docList.data);
                                        return ListTile(
                                          leading: CachedImage(
                                            memberInfo.profilePhoto ?? "",
                                            radius: 25,
                                            isRound: true,
                                          ),
                                          title: Container(
                                              width: 100,
                                              child: Text(
                                                memberInfo.name ?? 'SomeONe',
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        );
                                      }

                                      return Center(
                                          child: CircularProgressIndicator());
                                    });
                              })
                          : Container(),
                    ),
                    SizedBox(height: 5, child: Divider(height: 3)),
                    StreamBuilder(
                        stream: _contactMethods.fetchContacts(
                          userId: _authenticationService.currentUser.uid,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var docList = snapshot.data.documents;

                            if (docList.isEmpty) {
                              return ContactQuietBox();
                            }
                            return Expanded(
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 1),
                                  itemCount: docList.length,
                                  itemBuilder: (context, index) {
                                    Contact contact =
                                        Contact.fromMap(docList[index].data);
                                    print(contact.uid);
                                    return contactList(context, contact);
                                  }),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                  ],
                )),
      ),
    );
  }
}
