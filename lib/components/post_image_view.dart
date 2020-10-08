import 'package:bluu/pages/callscreens/pickup/pickup_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImages extends StatefulWidget {
  final List<NetworkImage> list;
  final String desc;
  final List likes;
  final List shares;
  final List reposts;

  const ViewImages(
      {Key key, this.list, this.desc, this.likes, this.shares, this.reposts})
      : super(key: key);

  @override
  _ViewImagesState createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  PageController _pageController;

  // ignore: unused_field
  int _page = 0;

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: SizedBox(),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Get.back(),
          )
        ],
      ),
      body: Stack(
        alignment: const Alignment(0.6, 0.6),
        children: [
          Container(
              child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: widget.list[index],
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.list[index]),
              );
            },
            itemCount: widget.list.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
            backgroundDecoration:
                BoxDecoration(color: Theme.of(context).canvasColor),
            pageController: _pageController,
            onPageChanged: onPageChanged,
          )),
          Positioned(
              bottom: 50,
              right: 50,
              child: Container(
                alignment: Alignment.bottomRight,
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.desc,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.grey[300],
                              size: 24.0,
                              semanticLabel: 'favorite',
                            ),
                            Text(widget.likes.length.toString())
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.add_to_photos_outlined,
                              color: Colors.grey[300],
                              size: 24.0,
                            ),
                            Text(widget.shares.length.toString())
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.read_more_sharp,
                              color: Colors.grey[300],
                              size: 24.0,
                            ),
                            Text(widget.reposts.length.toString())
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    ));
  }
}
