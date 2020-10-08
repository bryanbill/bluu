import 'package:bluu/components/post_image_view.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/pages/weview.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/viewmodels/home_view_model.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:bluu/pages/chatscreens/widgets/cached_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluu/widgets/image_card.dart';

const duration = Duration(milliseconds: 3000);

class PostWidget extends StatelessWidget {
  final HomeViewModel model;
  final List<NetworkImage> listOfImages;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final String desc;

  final String uid;
  final time;
  final List urls;
  final List shares;
  final List likes;
  final List repost;
  final postId;
  final int type;
  final List views;
  PostWidget(
      {Key key,
      this.listOfImages,
      this.postId,
      this.model,
      this.type,
      this.views,
      this.desc,
      this.uid,
      this.urls,
      this.time,
      this.shares,
      this.likes,
      this.repost})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _firestoreService.getUserDetailsById(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                type == 4
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Text('${user.name ?? ''} shared a post',
                            style: TextStyle(
                                fontSize: 9.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)),
                      )
                    : SizedBox(),
                ListTile(
                  leading: Container(
                      alignment: Alignment.centerLeft,
                      width: 50,
                      height: 50,
                      child: CachedImage(user.profilePhoto,
                          isRound: true, radius: 25)),
                  contentPadding: EdgeInsets.all(0),
                  title: Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        user.name ?? '',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(time ?? "2 am"),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ),
                ListTile(
                  title: Text(desc ?? ""),
                ),
                SimpleUrlPreview(
                  onTap: () => Get.to(WeViewPage(url: urls[0])),
                  url: urls.length > 0 ? urls[0] : '',
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: GestureDetector(
                      onTap: () => Get.to(ViewImages(
                            list: listOfImages,
                            reposts: views,
                            shares: shares,
                            likes: likes,
                            desc: desc,
                          )).then((value) =>
                              model.view(postId, model.currentUser.uid)),
                      child: ImageCard(images: listOfImages)),
                ),
                //   child: Carousel(
                //       onImageTap: (int index) {
                //         return Get.to(ViewImages(
                //           list: listOfImages,
                //           reposts: views,
                //           shares: shares,
                //           likes: likes,
                //           desc: desc,
                //         )).then((value) =>
                //             model.view(postId, model.currentUser.uid));
                //       },
                //       boxFit: BoxFit.cover,
                //       images: listOfImages,
                //       autoplay: false,
                //       showIndicator: listOfImages.length > 1 ? true : false,
                //       indicatorBgPadding: 5.0,
                //       dotPosition: DotPosition.topRight,
                //       animationCurve: Curves.easeIn,
                //       animationDuration: Duration(milliseconds: 2000)),
                // ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          color: likes.contains(model.currentUser.uid)
                              ? Colors.red
                              : Colors.grey[300],
                          iconSize: 24.0,
                          onPressed: () {
                            likes.contains(model.currentUser.uid)
                                ? model.unlikePost(
                                    postId, model.currentUser.uid)
                                : model.likePost(postId, model.currentUser.uid);
                          },
                        ),
                        Text(likes.length.toString())
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_to_photos_outlined),
                          color: shares.contains(model.currentUser.uid)
                              ? Colors.blueGrey
                              : Colors.grey[300],
                          iconSize: 24.0,
                          onPressed: () {
                            return model
                                .uploadImages(
                                    model.currentUser.uid,
                                    desc,
                                    listOfImages,
                                    Timestamp.now(),
                                    [],
                                    likes,
                                    shares,
                                    repost,
                                    urls,
                                    4)
                                .then((value) =>
                                    model.share(postId, model.currentUser.uid));
                          },
                        ),
                        Text(shares.length.toString())
                      ],
                    ),
                    views != null
                        ? Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.read_more_sharp),
                                color: views.contains(model.currentUser.uid)
                                    ? Colors.green[400]
                                    : Colors.grey[300],
                                iconSize: 24.0,
                                onPressed: () {
                                  return Get.defaultDialog(title: 'Viewed by:');
                                },
                              ),
                              Text(views.length.toString())
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
                SizedBox(height: 10),
              ],
            );
          } else {
            return SizedBox();
          }
        });
  }
}
