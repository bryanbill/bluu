import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

const duration = Duration(milliseconds: 3000);

class PostWidget extends StatelessWidget {
  final List<NetworkImage> listOfImages;
  final String desc;
  final String by;
  final time;
  final String profilePhoto;
  final List shares;
  final List likes;
  final List repost;
  const PostWidget(
      {Key key,
      this.listOfImages,
      this.desc,
      this.by,
      this.time,
      this.profilePhoto,
      this.shares,
      this.likes,
      this.repost})
      : super(key: key);

  void onStarted() {
    print("Ready");
  }

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
          subtitle: Text('Florida'),
        ),
        Container(
          height: 300,
          child: Carousel(
              boxFit: BoxFit.cover,
              images: listOfImages,
              autoplay: false,
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
                  color: Colors.pink,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                Text(likes.length.toString())
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.room,
                  color: Colors.green,
                  size: 30.0,
                ),
                Text(shares.length.toString())
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.explore,
                  color: Colors.blue,
                  size: 36.0,
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
