import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final List images;

  const ImageCard({Key key, this.images}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return buildImages(images);
  }

  Widget buildImages(List images) {
    if (images.length > 2) {
      return Container(
        height: 300.0,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  image: DecorationImage(image: NetworkImage(images[0]), fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 5.0,
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      image:
                          DecorationImage(image:NetworkImage(images[1]), fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      image:
                          DecorationImage(image: NetworkImage(images[2]), fit: BoxFit.cover)),
                ),
              ],
            )
          ],
        ),
      );
    } else if (images.length == 2) {
      return Container(
        height: 300.0,
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
                child: Image(
                  image: NetworkImage(images[0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 5.0),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
                child: Image(
                  image: NetworkImage(images[1]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 300.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            image: DecorationImage(image: NetworkImage(images[0]), fit: BoxFit.cover)),
      );
    }
  }
}
