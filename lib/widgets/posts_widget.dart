import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';


const duration = Duration(milliseconds: 3000);

class PostWidget extends StatelessWidget {
  final List<NetworkImage> listOfImages;

  const PostWidget({Key key, this.listOfImages}) : super(key: key);

  

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
        Container(
          height: 300,
          child: Carousel(
                                    boxFit: BoxFit.cover,
                                    images: listOfImages,
                                    autoplay: false,
                                    indicatorBgPadding: 5.0,
                                    dotPosition: DotPosition.bottomCenter,
                                    animationCurve: Curves.easeIn,
                                    animationDuration:
                                        Duration(milliseconds: 2000)),
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
    );
  }
}
