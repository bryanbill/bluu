import 'package:bluu/components/upload_images_page.dart';
import 'package:bluu/widgets/posts_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'callscreens/pickup/pickup_layout.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
 final _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      key:_globalKey,
      padding: const EdgeInsets.all(8.0),
      child: PageView(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          PickupLayout(scaffold: Posts()),
          PickupLayout(scaffold: UploadImages(globalKey: _globalKey))
        ],
      ),
    );
  }
}

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List<NetworkImage> _listOfImages = <NetworkImage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text("Community"),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('images').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
                _listOfImages = [];

                 
              return ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                 for (int i = 0;
                      i < snapshot.data.documents[index].data['urls'].length;
                      i++) {
                   
                      _listOfImages.add(NetworkImage(
                        snapshot.data.documents[index].data['urls'][i]));
                    
                  }
                  return PostWidget(
                    listOfImages: _listOfImages,
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
