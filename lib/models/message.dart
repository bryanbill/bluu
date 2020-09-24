import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;
  List urls;
  String replyText;
  bool isReply;

  Message(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.isReply,
      this.replyText,
      this.urls,
      this.timestamp});

  //Will be only called when you wish to send an image
  // named constructor
  Message.imageMessage(
      {this.senderId,
      this.receiverId,
      this.message,
      this.type,
      this.urls,
      this.isReply,
      this.replyText,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['urls'] = this.urls;
    map['isReply'] = this.isReply;
    map['replyText'] = this.replyText;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['urls'] = this.urls;
    map['isReply'] = this.isReply;
    map['replyText'] = this.replyText;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  // named constructor
  Message.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.urls = map['urls'];
    this.isReply = map['isReply'];
    this.replyText = map['replyText'];
    this.timestamp = map['timestamp'];
    this.photoUrl = map['photoUrl'];
  }
}
