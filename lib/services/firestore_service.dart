import 'dart:async';

import 'package:bluu/enum/user_state.dart';
import 'package:bluu/models/group.dart';
import 'package:bluu/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluu/models/post.dart';
import 'package:bluu/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _postsCollectionReference =
      Firestore.instance.collection('posts');

  final CollectionReference _groupsCollectionReference =
      Firestore.instance.collection('groups');

  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<Post>> _allPagedResults = List<List<Post>>();

  static const int PostsLimit = 2;

  DocumentSnapshot _lastDocument;
  bool _hasMorePosts = true;

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.uid).setData(user.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future createGroup(data) async {
    Group group = Group();
    try {
      await _groupsCollectionReference.add(group.toMap(data));
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromMap(userData.data);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future<List<User>> fetchAllUsers(User currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await _usersCollectionReference.getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<User> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _usersCollectionReference.document(id).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setUserState({@required userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _usersCollectionReference.document(userId).updateData({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) {
    return _usersCollectionReference.document(uid).snapshots();
  }

  Future addPost(Post post) async {
    try {
      await _postsCollectionReference.add(post.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future repost(
      {userId,
      time,
      desc,
      friends,
      likes,
      shares,
      views,
      urls,
      repostBy,
      imageUrls,
      type}) async {
    try {
      await _postsCollectionReference.add({
        'userId': userId,
        'repostBy':repostBy,
        'desc': desc,
        'imageUrl': imageUrls,
        'friends': [],
        'time':time,
        'type': type,
        'likes': likes,
        'shares': shares,
        'views': views,
        "urls": urls
      });
    } catch (e) {
      print("Error from repost: ${e.toString()}");
    }
  }

  Future getPostsOnceOff() async {
    try {
      var postDocumentSnapshot =
          await _postsCollectionReference.limit(PostsLimit).getDocuments();
      if (postDocumentSnapshot.documents.isNotEmpty) {
        return postDocumentSnapshot.documents
            .map((snapshot) => Post.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.userId != null)
            .toList();
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateProfilePic(userId, pic) async {
    try {
      await _usersCollectionReference
          .document(userId)
          .setData({"profile_photo": pic}, merge: true);
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateUserName(userId, userName) async {
    try {
      await _usersCollectionReference
          .document(userId)
          .setData({"username": userName}, merge: true);
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateFullName(userId, fullName) async {
    try {
      await _usersCollectionReference
          .document(userId)
          .setData({"name": fullName}, merge: true);
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateUserStatus(userId, userStatus) async {
    try {
      await _usersCollectionReference
          .document(userId)
          .setData({"status": userStatus}, merge: true);
    } catch (e) {
      print(e.toString());
    }
  }

  Future updatePhone(userId, phone) {
    //TODO: PHONE AUTH
  }
  Stream listenToPostsRealTime() {
    // Register the handler for when the posts data changes
    //_requestPosts();
    _postsCollectionReference
        .orderBy('time', descending: true)
        .snapshots()
        .listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((snapshot) => Post.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.userId != null)
            .toList();

        _postsController.add(posts);
      }
    });
    return _postsController.stream;
  }

  Future likePost(postId, userId) async {
    try {
      await _postsCollectionReference.document(postId).setData({
        'likes': FieldValue.arrayUnion([userId])
      }, merge: true);
    } catch (e) {
      print(e.toString());
    }
  }

  Future sharePost(postId, userId) async {
    try {
      await _postsCollectionReference.document(postId).setData({
        'shares': FieldValue.arrayUnion([userId])
      }, merge: true);
    } catch (e) {
      print(e.toString());
    }
  }

  Future addView(postId, userId) async {
    try {
      await _postsCollectionReference.document(postId).setData({
        'views': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future unlikePost(postId, userId) async {
    try {
      await _postsCollectionReference.document(postId).setData({
        'likes': FieldValue.arrayRemove([userId])
      }, merge: true);
    } catch (e) {
      print(e.toString());
    }
  }

  // #1: Move the request posts into it's own function
  void _requestPosts() {
    // #2: split the query from the actual subscription
    var pagePostsQuery = _postsCollectionReference
        .orderBy('time')
        // #3: Limit the amount of results
        .limit(PostsLimit);

    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pagePostsQuery = pagePostsQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMorePosts) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;

    pagePostsQuery.snapshots().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) { 
        var posts = postsSnapshot.documents
            .map((snapshot) => Post.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.userId != null)
            .toList();

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allPagedResults.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = posts;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allPagedResults.add(posts);
        }

        // #11: Concatenate the full list to be shown
        var allPosts = _allPagedResults.fold<List<Post>>(List<Post>(),
            (initialValue, pageItems) => initialValue..addAll(pageItems));

        // #12: Broadcase all posts
        _postsController.add(allPosts);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = postsSnapshot.documents.last;
        }

        // #14: Determine if there's more posts to request
        _hasMorePosts = posts.length == PostsLimit;
      }
    });
  }

  Future deletePost(String documentId) async {
    await _postsCollectionReference.document(documentId).delete();
  }

  Future updatePost(Post post) async {
    try {
      await _postsCollectionReference
          .document(post.documentId)
          .updateData(post.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  void requestMoreData() => _requestPosts();
}
