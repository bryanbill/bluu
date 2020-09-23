String urlLink(String text) {
  String urlLink;
  RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  Iterable<RegExpMatch> matches = exp.allMatches(text);
  List url = [];
  matches.forEach((match) {
    url.add(text.substring(match.start, match.end));
  });

  urlLink = url[0].toLowerCase().toString();
  return urlLink;
}
