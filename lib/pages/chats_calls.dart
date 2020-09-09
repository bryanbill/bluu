
import 'package:flutter/material.dart';

import 'pageviews/chat_lists/chat_list_screen.dart';
import 'pageviews/group_lists/group_list_screen.dart';

class ChatsCalls extends StatefulWidget {
  @override
  _ChatsCallsState createState() => _ChatsCallsState();
}

class _ChatsCallsState extends State<ChatsCalls>
   with WidgetsBindingObserver, SingleTickerProviderStateMixin  {
  PageController _pageController;
  int _page = 2;
 
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
   

    
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

 

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          title: TextField(
            decoration: InputDecoration.collapsed(
              hintText: 'Search',
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.filter_list,
              ),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).accentColor,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Theme.of(context).textTheme.caption.color,
            isScrollable: false,
            tabs: <Widget>[
              Tab(
                text: "Message",
              ),
              Tab(
                text: "Groups",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              child: ChatListScreen(),
            ),
            // Container(child: GroupListScreen()),
            Container(child: GroupListScreen())
          ],
        ));
  }
}
