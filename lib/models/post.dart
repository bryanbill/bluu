import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Post {
  final String desc;
  final List imageUrl;
  final String userId;
  final String documentId;
  final Timestamp time;
  final List friend;
  final int type;
  final List likes;
  final List shares;
  final List reposts;
  final List urls;
  final List views;

  Post({
    @required this.userId,
    @required this.desc,
    this.documentId,
    this.imageUrl,
    this.time,
    this.friend,
    this.type,
    this.likes,
    this.shares,
    this.reposts,
    this.views,
    this.urls,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'desc': desc,
      'imageUrl': imageUrl,
      'time': time,
      'friends': friend,
      'type': type,
      'likes': likes,
      'shares': shares,
      'reposts': reposts,
      'views': views,
      'urls': urls
    };
  }

  static Post fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Post(
        desc: map['desc'],
        imageUrl: map['imageUrl'],
        userId: map['userId'],
        documentId: documentId,
        time: map['time'],
        friend: map['friends'],
        type: map['type'],
        likes: map['likes'],
        shares: map['shares'],
        reposts: map['reposts'],
        views: map['views'],
        urls: map['urls']);
  }
}
