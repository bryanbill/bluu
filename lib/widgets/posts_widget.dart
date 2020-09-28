import 'package:bluu/components/post_image_view.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

const duration = Duration(milliseconds: 3000);

class PostWidget extends StatelessWidget {
  final List<NetworkImage> listOfImages;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final String desc;

  final String uid;
  final time;
  final List urls;
  final List shares;
  final List likes;
  final List repost;
  PostWidget(
      {Key key,
      this.listOfImages,
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
                ListTile(
                  leading: Container(
                    alignment: Alignment.centerLeft,
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.profilePhoto ?? '',
                      ),
                      radius: 25,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(0),
                  title: Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        user.name ?? "Smith Joe",
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
                  title: Text(desc ?? "CourseMate"),
                ),
                SimpleUrlPreview(url: urls[0]),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Carousel(
                      onImageTap: (int index) {
                        return Get.to(ViewImages(
                          list: listOfImages,
                          reposts: repost,
                          shares: shares,
                          likes: likes,
                          desc: desc,
                        ));
                      },
                      boxFit: BoxFit.cover,
                      images: listOfImages,
                      autoplay: true,
                      showIndicator: listOfImages.length > 1 ? true : false,
                      indicatorBgPadding: 5.0,
                      dotPosition: DotPosition.bottomCenter,
                      animationCurve: Curves.easeIn,
                      animationDuration: Duration(milliseconds: 2000)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.grey[300],
                          size: 24.0,
                        ),
                        Text(likes.length.toString())
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.room,
                          color: Colors.grey[300],
                          size: 24.0,
                        ),
                        Text(shares.length.toString())
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.explore,
                          color: Colors.grey[300],
                          size: 24.0,
                        ),
                        Text(repost.length.toString())
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            );
          } else {
            return Center(child: Text("Not a valid post"));
          }
        });
  }
}
