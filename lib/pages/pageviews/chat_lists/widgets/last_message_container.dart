import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/message.dart';
import 'package:intl/intl.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;

  LastMessageContainer({
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;

          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data);
            return SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: message.message != 'IMAGE'
                    ? Text(
                        message.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(),
                      )
                    : Container(
                        alignment: Alignment.bottomLeft,
                        child: Icon(Icons.image)));
          }

          return Text(
            "No Message",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
        return Text(
          "..",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }
}

class LastMessageTimeContainer extends StatelessWidget {
  final stream;

  LastMessageTimeContainer({
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;

          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data);

            var time = message.timestamp.toDate().toLocal();
            var newFormat = DateFormat("Hm");
            String timeT = newFormat.format(time);
            return Text(
              timeT,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            );
          }

          return Text(
            "0",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
        return Text(
          "..",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }
}
