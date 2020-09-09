import 'package:chatapp/components/page_heading.dart';
import 'package:chatapp/components/searchbar.dart';
import 'package:chatapp/pages/picker.dart';
import 'package:chatapp/widgets/posts_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PageView(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          PickupLayout(scaffold: Posts()),
          PickupLayout(scaffold: Picker())
        ],
      ),
    );
  }
}

class Posts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text("Community"),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          PostWidget(
              image:
                  "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/allbikes-1539286251.jpg"),
          PostWidget(
              image:
                  "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/allbikes-1539286251.jpg"),
          PostWidget(
              image:
                  "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/allbikes-1539286251.jpg"),
          PostWidget(
              image:
                  "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/allbikes-1539286251.jpg"),
        ],
      ),
    );
  }
}
