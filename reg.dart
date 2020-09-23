void main() {
  final text = "we have text with some url (https://some.url.link)";
  RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  Iterable<RegExpMatch> matches = exp.allMatches(text);
  List url = [];
  matches.forEach((match) {
    url.add(text.substring(match.start, match.end));
  });

  print(url[0].toString());
}
