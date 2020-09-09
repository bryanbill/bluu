import 'package:bluu/utils/src/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

const duration = Duration(milliseconds: 3000);

class PostWidget extends StatelessWidget {
  final image;

  const PostWidget({Key key, this.image}) : super(key: key);

  String hash() {
    Uint8List fileData = File("$image").readAsBytesSync();
    img.Image imageData = img.decodeImage(fileData.toList());

    final blurHash = encodeBlurHash(
      imageData.getBytes(format: img.Format.rgba),
      imageData.width,
      imageData.height,
    );
    return blurHash;
  }

  void onStarted() {
    print("Ready");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Container(
                alignment: Alignment.centerLeft,
                width: 50,
                height: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1598134502770-08c90ca7a22d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
                  radius: 25,
                )),
            contentPadding: EdgeInsets.all(0),
            title: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  "Smith Joe",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Text("2 am"),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          ListTile(
            title: Text("CourseMate"),
            subtitle: Text('Florida'),
          ),
          Hero(
            tag: "12",
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: BlurHash(
                onStarted: onStarted,
                hash: "LGF5]+Yk^6#M@-5c,1J5@[or[Q6.",
                image: image,
                duration: duration,
              ),
            ),
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
                  Text("120K")
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.room,
                    color: Colors.green,
                    size: 30.0,
                  ),
                  Text("450")
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.explore,
                    color: Colors.blue,
                    size: 36.0,
                  ),
                  Text("567")
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
