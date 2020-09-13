import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String docId;
  String uid;
  String name;
  List users;
  String desc;
  String avatar;
  bool public;
  bool limit;
  String link;
  Timestamp createdOn;
  String firebaseToken;

  Group({
    this.uid,
    this.docId,
    this.firebaseToken,
    this.users,
    this.name,
    this.avatar,
    this.public,
    this.limit,
    this.link,
    this.desc,
    this.createdOn,
  });

  Map toMap(Group group) {
    var data = Map<String, dynamic>();
    data['token'] = group.firebaseToken;
    data['contact_id'] = group.uid;
    data['name'] = group.name;
    data['users'] = group.users;
    data['avatar'] = group.avatar;
    data['public'] = group.public;
    data['limit'] = group.limit;
    data['link'] = group.link;
    data['desc'] = group.desc;
    data['created_on'] = group.createdOn;
    return data;
  }

  Group.fromMap(Map<String, dynamic> mapData, docId) {
    this.uid = mapData['contact_id'];
    this.firebaseToken = mapData['token'];
    this.docId = docId;
    this.name = mapData['name'];
    this.users = mapData['users'];
    this.avatar = mapData['avatar'];
    this.public = mapData['public'];
    this.limit = mapData['limit'];
    this.link = mapData['link'];
    this.desc = mapData['desc'];
    this.createdOn = mapData["created_on"];
  }
}
