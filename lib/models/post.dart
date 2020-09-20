import 'package:flutter/foundation.dart';

class Post {
  final String desc;
  final List imageUrl;
  final String userId;
  final String documentId;


  Post({
    @required this.userId,
    @required this.desc,
    this.documentId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'desc': desc,
      'imageUrl': imageUrl,
    };
  }

  static Post fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Post(
      desc: map['desc'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
      documentId: documentId,
    );
  }
}
