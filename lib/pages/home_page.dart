import 'package:bluu/components/upload_images_page.dart';
import 'package:bluu/viewmodels/home_view_model.dart';
import 'package:bluu/widgets/posts_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bluu/utils/time_ago.dart';
import 'callscreens/pickup/pickup_layout.dart';
import 'package:get/get.dart';

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

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> with AutomaticKeepAliveClientMixin {
  List<NetworkImage> _listOfImages = <NetworkImage>[];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (model) => model.listenToPosts(),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                title: Text("Community"),
              ),
              body: model.posts != null
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      itemCount: model.posts.length,
                      itemBuilder: (context, index) {
                        // if (model.posts.length > index)
                        //   Get.snackbar("Post", "New posts available",
                        //       colorText: Colors.white);

                        _listOfImages = [];
                        for (int i = 0;
                            i < model.posts[index].imageUrl.length;
                            i++) {
                          _listOfImages.add(
                              NetworkImage(model.posts[index].imageUrl[i]));
                        }
                        String time = timeAgo(model.posts[index].time);

                        return PostWidget(
                            model: model,
                            postId: model.posts[index].documentId,
                            listOfImages: _listOfImages,
                            desc: model.posts[index].desc,
                            uid: model.posts[index].userId,
                            likes: model.posts[index].likes,
                            shares: model.posts[index].shares,
                            time: time,
                            repost: model.posts[index].reposts,
                            urls: model.posts[index].urls);
                      },
                    )
                  : SizedBox());
        });
  }
}
