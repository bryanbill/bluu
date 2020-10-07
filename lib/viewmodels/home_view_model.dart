import 'package:bluu/constants/route_names.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/models/post.dart';
import 'package:bluu/services/cloud_storage_service.dart';
import 'package:bluu/services/dialog_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/services/navigation_service.dart';
import 'package:bluu/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  List<Post> _posts;
  List<Post> get posts => _posts;
  void listenToPosts() {
    setBusy(true);

    _firestoreService.listenToPostsRealTime().listen((postsData) {
      List<Post> updatedPosts = postsData;
      if (updatedPosts != null && updatedPosts.length > 0) {
        _posts = updatedPosts;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  Future likePost(postId, userId) async {
    setBusy(true);
    await _firestoreService.likePost(postId, userId);
    setBusy(false);
  }

  Future unlikePost(postId, userId) async {
    setBusy(true);
    await _firestoreService.unlikePost(postId, userId);
    setBusy(false);
  }

  Future share(postId, userId) async {
    setBusy(true);
     await _firestoreService.sharePost(postId, userId);
    setBusy(false);
  }

  Future deletePost(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the post?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      var postToDelete = _posts[index];
      setBusy(true);
      await _firestoreService.deletePost(postToDelete.documentId);
      // Delete the image after the post is deleted
      //await _cloudStorageService.deleteImage(postToDelete.imageFileName);
      setBusy(false);
    }
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  void editPost(int index) {
    _navigationService.navigateTo(CreatePostViewRoute,
        arguments: _posts[index]);
  }

  Future uploadImages(
      String userId,
      String desc,
      List imageUrl,
      Timestamp time,
      List friends,
      List likes,
      List shares,
      List reposts,
      List urls,
      int type) async {
    setBusy(true);
    await _firestoreService
        .addPost(Post(
            userId: userId,
            desc: desc,
            imageUrl: imageUrl,
            time: time,
            friend: friends,
            likes: likes,
            shares: shares,
            reposts: reposts,
            urls: urls,
            type: type))
        .whenComplete(() => setBusy(false));
  }

  void requestMoreData() => _firestoreService.requestMoreData();
}
