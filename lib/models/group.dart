import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String uid;
  List users;
  String desc;
  String avatar;
  bool public;
  bool limit;
  String link;
  Timestamp createdOn;

  Group({
    this.uid,
    this.users,
    this.avatar,
    this.public,
    this.limit,
    this.link,
    this.desc,
    this.createdOn,
  });

  Map toMap(Group contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['users'] = contact.users;
    data['avatar'] = contact.avatar;
    data['public'] = contact.public;
    data['limit'] = contact.limit;
    data['link'] = contact.link;
    data['desc'] = contact.desc;
    data['created_on'] = contact.createdOn;
    return data;
  }

  Group.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'];
    this.users = mapData['users'];
    this.avatar = mapData['avatar'];
    this.public = mapData['public'];
    this.limit = mapData['limit'];
    this.link = mapData['link'];
    this.desc = mapData['desc'];
    this.createdOn = mapData["created_on"];
  }
}
