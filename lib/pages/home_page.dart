import 'package:bluu/components/upload_images_page.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/viewmodels/home_view_model.dart';
import 'package:bluu/widgets/posts_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'callscreens/pickup/pickup_layout.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
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

  final _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: _globalKey,
      padding: const EdgeInsets.all(8.0),
      child: PageView(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          PickupLayout(scaffold: Posts()),
          PickupLayout(scaffold: UploadImages(page: _pageController))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Posts extends StatelessWidget {
  List<NetworkImage> _listOfImages = <NetworkImage>[];

  // final AuthenticationService _authenticationService =
  //     locator<AuthenticationService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (model) => model.listenToPosts(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).canvasColor,
              title: Text("Community"),
            ),
            body: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: model.posts.length,
              itemBuilder: (context, index) {
                _listOfImages = [];
                for (int i = 0; i < model.posts[index].imageUrl.length; i++) {
                  _listOfImages
                      .add(NetworkImage(model.posts[index].imageUrl[i]));
                }

                Timestamp timeStamp = model.posts[index].time;

                DateTime dt = timeStamp.toDate();
                DateTime now = DateTime.now();
                int diff1 = now.difference(dt).inMinutes;
                int diff2 = now.difference(dt).inHours;
                int diff3 = now.difference(dt).inDays;
                int diff4 = (diff3 / 4).round();
                String time;
                if (diff1 < 6) {
                  time = "Moments Ago";
                } else {
                  if (diff1 > 5 && diff1 <= 59) {
                    time = diff1.toString() + 'm Ago';
                  } else {
                    if (diff2 < 24) {
                      time = diff2.toString() + 'h ago';
                    } else {
                      if (diff3 < 8) {
                        time = diff3.toString() + 'd ago';
                      } else if (diff3 > 7 && diff4 < 5) {
                        time = diff3.toString() + 'w ago';
                      } else if (diff4 > 5) {
                        int months = diff4.floor();

                        time = months.toString() + 'months ago';
                      }
                    }
                  }
                }
                print(diff1.toString());
                return PostWidget(
                  listOfImages: _listOfImages,
                  desc: model.posts[index].desc,
                  uid: model.posts[index].userId,
                  likes: model.posts[index].likes,
                  shares: model.posts[index].shares,
                  time: time,
                  repost: model.posts[index].reposts,
                  urls: model.posts[index].urls
                );
              },
            )));
  }
}
