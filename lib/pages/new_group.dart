import 'package:bluu/models/contact.dart';
import 'package:bluu/models/group.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/resources/contact_methods.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/widgets/quiet_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chatscreens/widgets/cached_image.dart';

class NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

final AuthenticationService _authenticationService =
    locator<AuthenticationService>();
final ContactMethods _contactMethods = ContactMethods();
final FirestoreService _firestoreService = locator<FirestoreService>();

class _NewGroupState extends State<NewGroup> {
  TextEditingController _text = TextEditingController();

  List _uids = [_authenticationService.currentUser.username];
  int _value = 0;

  createGroup(Group group){
    
  }
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
                        onPressed: () {},
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
              child: ListTile(
                  leading: CachedImage(
                    user.profilePhoto,
                    radius: 50,
                    isRound: true,
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.username ?? '..'),
                  trailing: _uids.contains(user.name)
                      ? IconButton(
                          icon: Icon(Icons.done,
                              color: Theme.of(context).accentColor),
                          onPressed: () {
                            setState(() {
                              _uids.remove(user.name);
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _uids.add(user.name);
                            });
                          })),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: TextField(
          inputFormatters: [
            new LengthLimitingTextInputFormatter(20),
          ],
          controller: _text,
          onChanged: (value) {
            setState(() {
              _value = value.length;
            });
          },
          decoration: InputDecoration(
              suffix: Text((20 - _value).toString(),
                  style:
                      TextStyle(color: (20 - _value < 6) ? Colors.red : null))),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
              if (_value != 0 && _uids.length != 0) _displayDialog(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(child: Text(_uids.length.toString())),
          Container(
            height: 200,
            child: ListView.builder(
                itemCount: _uids.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                        width: 100,
                        child: Text(
                          _uids[index] ?? 'SomeONe',
                          overflow: TextOverflow.ellipsis,
                        )),
                  );
                }),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1),
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
      ),
    );
  }
}
