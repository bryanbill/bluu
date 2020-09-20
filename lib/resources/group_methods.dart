import 'dart:math';
import 'package:bluu/models/message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluu/constants/strings.dart';
import 'package:bluu/models/group.dart';
import 'package:bluu/models/user.dart';

class GroupMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _messageCollection =
      _firestore.collection('group_messages');

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);
  final CollectionReference _groupCollection =
      _firestore.collection(GROUPS_COLLECTION);

  Future<void> addMessageToDb(
      Message message, User sender, Group receiver) async {
    var map = message.toMap();

    await _messageCollection
        .document(receiver.docId)
        .collection('messages')
        .add(map);
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _messageCollection
        .document(receiverId)
        .collection('messages')
        .add(map);

  }

  Future<void> addGroupToDb(User sender, User receiver) async {
    addToGroups(senderId: sender.uid, receiverId: receiver.uid);
  }

  DocumentReference getGroupsDocument({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(GROUPS_COLLECTION)
          .document("group_" + Random().nextInt(1000).toString());

  addToGroups({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderGroups(senderId, receiverId, currentTime);
    await addToReceiverGroups(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderGroups(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getGroupsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Group receiverGroup = Group(
        uid: receiverId,
        createdOn: currentTime,
      );

      var receiverMap = receiverGroup.toMap(receiverGroup);

      await getGroupsDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverGroups(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getGroupsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Group senderGroup = Group(
        uid: senderId,
        createdOn: currentTime,
      );

      var senderMap = senderGroup.toMap(senderGroup);

      await getGroupsDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchGroups({String userId}) =>
      _groupCollection.where('users', arrayContains: userId).snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({@required String groupId}) =>
      _messageCollection.orderBy("timestamp").snapshots();
}
