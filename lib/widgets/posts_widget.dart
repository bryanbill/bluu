import 'package:bluu/components/post_image_view.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const duration = Duration(milliseconds: 3000);

class PostWidget extends StatelessWidget {
  final List<NetworkImage> listOfImages;
  final String desc;
  final String by;
  final String uid;
  final time;
  final String profilePhoto;
  final List shares;
  final List likes;
  final List repost;
  PostWidget(
      {Key key,
      this.listOfImages,
      this.desc,
      this.by,
      this.uid,
      this.time,
      this.profilePhoto,
      this.shares,
      this.likes,
      this.repost})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                profilePhoto ?? '',
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
                by ?? "Smith Joe",
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
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
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
  }
}
