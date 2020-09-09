import 'package:flutter/material.dart';

import '../logic/bloc.dart';

//This is SearchBar.
class SearchBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: TextField(
        style: TextStyle(
          color: Colors.black
        ),
        decoration: InputDecoration(
         
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            size: 20,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.black
          )
        ),
        onChanged: (value) {
          bloc.feedSearchVal(value);
        },
      ),
      decoration: BoxDecoration(
        color: Color(0xffefefef),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
