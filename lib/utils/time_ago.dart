import 'package:cloud_firestore/cloud_firestore.dart';

String timeAgo(Timestamp time) {
  ///convert the {[time]} to {[toDate()]}
  DateTime rawTime = time.toDate();

  ///perform the time differece between the post time and the local time
  ///
  ///return the time span(difference) in between
  //NOTE:Span is the time difference

  Duration span = DateTime.now().difference(rawTime);

  ///converted time ago value
  String conTime;
  if (span.inMinutes < 2) {
    conTime = 'Moments ago';
  } else if (span.inMinutes > 2 && span.inMinutes < 59) {
    conTime = span.inMinutes.toString() + 'm ago';
  } else if (span.inHours < 23) {
    conTime = span.inHours.toString() + 'h ago';
  } else if (span.inDays < 7) {
    conTime = span.inDays.toString() + 'd ago';
  } else if (span.inDays > 7 && span.inDays < 30) {
    switch ((span.inDays / 7).round().toString()) {
      case '1':
        conTime = '1w ago';
        break;
      case '2':
        conTime = '2w ago';
        break;
      case '3':
        conTime = '3w ago';
        break;
      case '4':
        conTime = "4w ago";
        break;
      default:
        conTime = 'error';
    }
  } else {
    ///if the time span is greater than one month
    ///{[conTime.value > 30]}
    ///return the actual date of the post time in {[dd/mm/yyyy]}
    conTime = time.toDate().day.toString() +
        '/' +
        time.toDate().month.toString() +
        '/' +
        time.toDate().year.toString();
  }

  ///return converted time value
  ///{[conTime ?? '']}
  ///if the convertime value is ull, return an empty string

  print("The time: " + conTime);
  return conTime ?? '';
}
