import 'package:bluu/pages/callscreens/pickup/pickup_layout.dart';
import 'package:bluu/pages/pageviews/log_lists/widgets/floating_column.dart';
import 'package:flutter/material.dart';
import 'widgets/log_list_container.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return PickupLayout(
      scaffold: Scaffold(
        floatingActionButton: FloatingColumn(),
        body: Center(
          child: LogListContainer(),
        ),
      ),
    );
  }
}
